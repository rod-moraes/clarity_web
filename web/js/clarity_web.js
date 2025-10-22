window.clarityLib = {
  clarityScript: function (projectId){
    (function(c,l,a,r,i,t,y){
        c[a]=c[a]||function(){(c[a].q=c[a].q||[]).push(arguments)};
        t=l.createElement(r);t.async=1;t.src="https://www.clarity.ms/tag/"+i;
        y=l.getElementsByTagName(r)[0];y.parentNode.insertBefore(t,y);
    })(window, document, "clarity", "script", projectId)
  },

  clarityInit: function (projectId, targetFpsMax = 5, targetFpsMin = 2, quality = 0.05){
    window.clarityLib.clarityScript(projectId);
    window.isCanvasMirrorActive = false;
    (() => {
      function onReady(cb) {
        if (document.readyState === 'complete' || document.readyState === 'interactive') {
          cb();
        } else {
          document.addEventListener('DOMContentLoaded', cb);
        }
      }
    
      onReady(() => {
        const orig = HTMLCanvasElement.prototype.getContext;
        HTMLCanvasElement.prototype.getContext = function (t, a) {
          if (t === 'webgl' || t === 'webgl2') {
            a = Object.assign({}, a, { preserveDrawingBuffer: true });
          }
          return orig.call(this, t, a);
        };
        const overlay = document.createElement('img');
        Object.assign(overlay.style, {
          position: 'fixed',
          top: '0',
          left: '0',
          width: '100vw',
          height: '100vh',
          objectFit: 'cover',
          pointerEvents: 'none',
          background: '#000',
          display: 'block',
          visibility: 'hidden',
        });
    
        function addOverlay() {
          const flutterView = document.querySelector('flutter-view');
          if (flutterView) {
            flutterView.parentNode.insertBefore(overlay, flutterView);
          } else {
            document.body.appendChild(overlay);
          }
        }

        if (!document.body) {
          console.warn('⏳ Aguardando o body...');
          const observer = new MutationObserver(() => {
            if (document.body) {
              observer.disconnect();
              addOverlay();
            }
          });
        
          observer.observe(document.documentElement, { childList: true, subtree: true });
        } else {
          addOverlay();
        }
        let lastTime = 0;
        let targetFps = targetFpsMax;
        let lowPower = false;
        function update(now) {
          try {
            let frameInterval = 1000 / targetFps;
            if (document.hidden || !window.isCanvasMirrorActive) {
              overlay.style.visibility = 'hidden';
              requestAnimationFrame(update);
              return;
            }
            const elapsed = now - lastTime;
            if (elapsed < frameInterval) {
              requestAnimationFrame(update);
              return;
            }
            lastTime = now;
            const glass = document.querySelector('flt-glass-pane');
            const canvas = glass?.shadowRoot?.querySelector('canvas');
            if (!canvas || canvas.width === 0) return requestAnimationFrame(update);

            overlay.style.visibility = 'visible';
            const dataUrl = canvas.toDataURL('image/jpeg',quality);
            overlay.src = dataUrl;
          } catch (err) {
            console.warn('⚠️ Erro ao capturar canvas:', err);
          }
          lowPower = performance.now() - now > 50;
          targetFps = lowPower ? targetFpsMin : targetFpsMax;
          requestAnimationFrame(update);
        };
        requestAnimationFrame(update);
      });
    })();
}
}