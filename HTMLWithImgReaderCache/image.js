
function connectWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) {
        callback(WebViewJavascriptBridge)
    } else {
        document.addEventListener('WebViewJavascriptBridgeReady',   function() {
                                  callback(WebViewJavascriptBridge)
                                  }, false)
    }
}

function imagesDownloadComplete(pOldUrl, pNewUrl) {
    
    var allImage = document.querySelectorAll("img");
    allImage = Array.prototype.slice.call(allImage,0);
    allImage.forEach(function(image) {
     if (image.getAttribute("esrc") == pOldUrl || image.getAttribute("esrc") == decodeURIComponent(pOldUrl)) {
     image.src = pNewUrl;
     }
    });
}

function onLoaded(){
    connectWebViewJavascriptBridge(function(bridge){
       bridge.init();
        /*
         [_bridge callHandler:@"imagesDownloadComplete" data:@[key,source]];
         bridge.registerHandler('imagesDownloadComplete', function (data)
         imagesDownloadComplete 一定要保持一致
         */
       bridge.registerHandler('imagesDownloadComplete', function (data){
                              imagesDownloadComplete(data[0],data[1]);
        });
       var allImage = document.querySelectorAll("img");
       allImage = Array.prototype.slice.call(allImage,0);
       
       var imageUrlsArray = new Array();
       
       allImage.forEach(function(image){
                        var esrc = image.getAttribute("esrc");
                        var newLength = imageUrlsArray.push(esrc);
                        });
       bridge.send(imageUrlsArray);
                                   
       });
}
//点击图片事件
function onImageClick(img) {
    connectWebViewJavascriptBridge(function(bridge){
    
       var allImage = document.querySelectorAll("img");
       allImage = Array.prototype.slice.call(allImage,0);
       var x = img.getBoundingClientRect().left;
       var y = img.getBoundingClientRect().top;
       x = x + document.documentElement.scrollLeft;
       y = y + document.documentElement.scrollTop;
       var  width = img.width;
       var  height = img.height;
                                   
       var index = -1;
       var picUrl = img.getAttribute("esrc");
       for (i = 0;i<allImage.length;i ++ ){
           var imgUrl = allImage[i].getAttribute("esrc");
           if(imgUrl == picUrl || imgUrl == decodeURIComponent(picUrl)){
           index = i;
           
           }
                                   }
       bridge.callHandler('imageDidClicked', {'index':index,'x':x,'y':y,'width':width,'height':height});
    });
}
