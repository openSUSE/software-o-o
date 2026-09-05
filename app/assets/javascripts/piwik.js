let _paq = _paq || [];
(function(){
  let u="https://beans.opensuse.org/piwik/";
  _paq.push(['setSiteId', 7]);
  _paq.push(['setTrackerUrl', u+'piwik.php']);
  _paq.push(['trackPageView']);
  _paq.push([ 'setDomains', ["*.opensuse.org"]]);
  let d=document,
  g=d.createElement('script'),
  s=d.getElementsByTagName('script')[0];
  g.type='text/javascript';
  g.defer=true;
  g.async=true;
  g.src=u+'piwik.js';
  s.parentNode.insertBefore(g,s);
})();
