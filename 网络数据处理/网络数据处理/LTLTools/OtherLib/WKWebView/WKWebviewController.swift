
import UIKit
import WebKit
import SnapKit


class WKWebviewController :UIViewController
{
    
    internal var urlString:String = ""

    private var leftBarButton:UIBarButtonItem?
    private var leftBarButtonSecond:UIBarButtonItem?
    private var negativeSpacer:UIBarButtonItem?

    ///web
    private var web:WebView = WebView()
    ///web配置
    var webConfig = WkwebViewConfig()
    
    /*
     *创建BarButtonItem
     */
    func setupBarButtonItem()
    {
        let button = UIButton()
            button.setImage(BackImage.imageOfBackChevron(), for: .normal)
            button.setTitle("返回", for: .normal)
            button.setTitleColor(UINavigationBar.appearance().tintColor, for: .normal)
            button.addTarget(self, action: #selector(WKWebviewController.selectedToBack), for: .touchUpInside)
            button.contentEdgeInsets = UIEdgeInsetsMake(0, -9, 0, 0);
        self.leftBarButton = UIBarButtonItem(customView: button)
       
        self.negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        self.leftBarButtonSecond = UIBarButtonItem(barButtonSystemItem: .stop , target: self, action: #selector(WKWebviewController.selectedToClose))
        //self.leftBarButtonSecond?.imageInsets = UIEdgeInsetsMake(0, -20, 0, 20)
        
    }

    /*
     *返回按钮执行事件
     */
    @objc func selectedToBack()
    {
        web.goBack()
    }
    /*
     *关闭按钮执行事件
     */
    @objc func selectedToClose()
    {
        
        if navigationController?.topViewController == self {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        setupBarButtonItem()

        view.addSubview(web)
        web.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.right.left.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
        // 消除底部导航栏的js代码
        //NSString *js = @"document.getElementsByClassName('pf_footer')[0].style.display = 'none'";
        webConfig.js = "document.getElementsByClassName('pf_footer')[0].style.display = 'none'"
        //webConfig.progressTintColor = MKDefineZhuTiColor
        webConfig.scriptMessageHandlerArray = ["wxModel"]
       
        web.webConfig = webConfig
        
        web.delegate = self
        
        web.webloadType(self, WkwebLoadType.URLString(url: urlString))
    }
    
    ////请求
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        LTLLog("开始请求")
    }

}
extension WKWebviewController : WKWebViewDelegate
{
    func title(_ webView: WKWebView) {
        LTLLog(webView.title)
        self.title = webView.title
        self.navigationController?.title = webView.title
    }
    func canGoBack(_ webView: WKWebView) {
        if webView.canGoBack
        {
            if ((navigationController?.viewControllers.index(of: self)) != nil) && (navigationController?.viewControllers.index(of: self))! > 0
            {
                navigationItem.leftBarButtonItems = [leftBarButton!,negativeSpacer!,leftBarButtonSecond!]
            }
            else
            {
                navigationItem.leftBarButtonItem = leftBarButton
            }
            
        }
        else
        {
            self.navigationItem.leftBarButtonItems = nil
        }
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        LTLLog("开始加载")
    }
  
    
}
