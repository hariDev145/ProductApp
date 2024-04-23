//
//  ProductDetailViewController.swift
//  ProductApp
//
//  Created by 2714476 on 17/04/24.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var titleContentLbl: UILabel!
    @IBOutlet weak var brandContentLbl: UILabel!
    @IBOutlet weak var priceContentLbl: UILabel!
    @IBOutlet weak var discountContentLbl: UILabel!
    @IBOutlet weak var stockContentLbl: UILabel!
    @IBOutlet weak var categoryContentLbl: UILabel!
    @IBOutlet weak var descriptionContentLbl: UILabel!
    
    @IBOutlet weak var pagingScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pagingContentView: UIView!
    @IBOutlet weak var addToCartBtn: UIButton!
    
    var presenter: (ViewToPresenterProductDetailProtocol & InteractorToPresenterProductDetailProtocol)?
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green]
    var productImages = [String]()
    var currentPage = 1;
    var slideTimer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        configurePageControl()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        slideTimer?.invalidate()
    }
    
    @IBAction func addToCartBtnAction(_ sender: Any) {
        presenter?.storeProductObjectInCoreData()
    }
}




extension ProductDetailViewController: UIScrollViewDelegate {
    
    func setupUI(){
        self.title = Constants.productDetailTitle
        let frame_width = self.view.frame.size.width - 20
        let frame = CGRect(x: 0, y: 0, width: frame_width, height: 215)
        pagingScrollView.frame = frame
        addToCartBtn.layer.cornerRadius = addToCartBtn.frame.size.height/2
        pagingScrollView.delegate = self
        pagingScrollView.isPagingEnabled = true
        pagingScrollView.showsHorizontalScrollIndicator = false
        
        for index in 0..<productImages.count{
            let frame_x = pagingScrollView.frame.size.width * CGFloat(index)
            let frame = CGRect(x: frame_x, y: 0, width: pagingScrollView.frame.size.width, height: pagingScrollView.frame.size.height)
            let pagingImgView = UIImageView(frame: frame)
            pagingImgView.backgroundColor = UIColor.random
            presenter?.getProductDetailImage(imageUrl: self.productImages[index], imgView: pagingImgView)
            pagingScrollView.addSubview(pagingImgView)
        }
        
        self.pagingScrollView.contentSize = CGSize(width:self.pagingScrollView.frame.size.width * CGFloat(productImages.count),height: self.pagingScrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
        
        slideTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(scrollPages), userInfo: nil, repeats: true)
    }
    
    
    func configurePageControl() {
        self.pageControl.numberOfPages = productImages.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.orange
        self.pageControl.pageIndicatorTintColor = UIColor.darkGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.orange
        self.pagingContentView.addSubview(pageControl)
    }
    
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * pagingScrollView.frame.size.width
        pagingScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    
    @objc func scrollPages() {
        if currentPage == self.productImages.count {
            currentPage = 0
        }
        scrollToPage(page: CGFloat(currentPage));
        currentPage+=1;
    }
    
    func scrollToPage(page : CGFloat) {
        pageControl.currentPage = Int(page)
        let pageWidth = pagingScrollView.frame.width
        pagingScrollView.setContentOffset(CGPoint(x: pageWidth * page, y: 0.0), animated: true)
    }
    
}





extension ProductDetailViewController: PresenterToViewProductDetailProtocol{
    
    func didStoreProductObjectInCoreData(success: Bool) {
        if success {
            var cartCount = UserDefaults.standard.integer(forKey: Constants.cartCountKey)
            cartCount += 1
            UserDefaults.standard.setValue(cartCount, forKey: Constants.cartCountKey)
            self.showToast(message: Constants.cartProductAddedMsg, font: .systemFont(ofSize: 12.0))
        }else{
            self.showToast(message: Constants.cartProductExistsMsg, font: .systemFont(ofSize: 12.0))
        }
    }
    
    func didStoreProductObjectInCoreData(failure: Bool) {
        if failure{
            self.showToast(message: Constants.somethingWrongMsg, font: .systemFont(ofSize: 12.0))
        }
    }
    
    func retrieveProductDetailSuccess(productsList: Product?) {
        if let product = productsList{
            self.titleContentLbl.text = product.title
            self.brandContentLbl.text = product.brand
            self.priceContentLbl.text = "$\(String(product.price))"
            self.discountContentLbl.text = String(product.discountPercentage)
            self.stockContentLbl.text = String(product.stock)
            self.categoryContentLbl.text = product.category
            self.descriptionContentLbl.text = product.description
            
            self.productImages.append(contentsOf: product.images)
        }
    }
    
}
