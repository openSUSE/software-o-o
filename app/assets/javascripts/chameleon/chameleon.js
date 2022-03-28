(function(){function r(e,n,t){function o(i,f){if(!n[i]){if(!e[i]){var c="function"==typeof require&&require;if(!f&&c)return c(i,!0);if(u)return u(i,!0);var a=new Error("Cannot find module '"+i+"'");throw a.code="MODULE_NOT_FOUND",a}var p=n[i]={exports:{}};e[i][0].call(p.exports,function(r){var n=e[i][1][r];return o(n||r)},p,p.exports,r,e,n,t)}return n[i].exports}for(var u="function"==typeof require&&require,i=0;i<t.length;i++)o(t[i]);return o}return r})()({1:[function(require,module,exports){
!function(e,t){"object"==typeof exports&&"object"==typeof module?module.exports=t():"function"==typeof define&&define.amd?define([],t):"object"==typeof exports?exports.StickyScroller=t():e.StickyScroller=t()}(window,function(){return function(e){var t={};function o(n){if(t[n])return t[n].exports;var i=t[n]={i:n,l:!1,exports:{}};return e[n].call(i.exports,i,i.exports,o),i.l=!0,i.exports}return o.m=e,o.c=t,o.d=function(e,t,n){o.o(e,t)||Object.defineProperty(e,t,{configurable:!1,enumerable:!0,get:n})},o.r=function(e){Object.defineProperty(e,"__esModule",{value:!0})},o.n=function(e){var t=e&&e.__esModule?function(){return e.default}:function(){return e};return o.d(t,"a",t),t},o.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},o.p="",o(o.s=0)}([function(e,t){e.exports=class{constructor(e,t){if(this.newScrollPosition=0,this.oldScrollPositon=0,this.ticking=!1,"string"==typeof e)this.element=document.querySelector(e);else{if(!(e instanceof HTMLElement))return void console.error("StickyScroller: element is required.");this.element=e}this.element.style.overflowY="hidden",window.addEventListener("scroll",this.onWindowScroll.bind(this))}onWindowScroll(){this.newScrollPosition=window.scrollY,this.ticking||(window.requestAnimationFrame(()=>{this.translate(),this.ticking=!1,this.oldScrollPositon=this.newScrollPosition}),this.ticking=!0)}translate(){const e=this.element.parentElement.getBoundingClientRect(),t=this.newScrollPosition-this.oldScrollPositon;e.top>0&&t>0||e.bottom<window.innerHeight&&t<0||(this.element.scrollTop=this.element.scrollTop+t)}}}])});
},{}],2:[function(require,module,exports){
/**
 * For webistes that already provide Bootstrap JavaScript.
 *
 * Examples: Weblate (l10n.opensuse.org), Cachet (status.opensuse.org)
 */

require("./megamenu");
require("./toc");

},{"./megamenu":5,"./toc":6}],3:[function(require,module,exports){
const langs = {};

langs["da"] = require("../../langs/da.json");
langs["de"] = require("../../langs/de.json");
langs["en"] = require("../../langs/en.json");
langs["es"] = require("../../langs/es.json");
langs["et"] = require("../../langs/et.json");
langs["fa"] = require("../../langs/fa.json");
langs["fi"] = require("../../langs/fi.json");
langs["hi"] = require("../../langs/hi.json");
langs["it"] = require("../../langs/it.json");
langs["ja"] = require("../../langs/ja.json");
langs["ko"] = require("../../langs/ko.json");
langs["pl"] = require("../../langs/pl.json");
langs["pt-BR"] = require("../../langs/pt_BR.json");
langs["pt"] = langs["pt-BR"];
langs["ru"] = require("../../langs/ru.json");
langs["sv"] = require("../../langs/sv.json");
langs["zh-CN"] = require("../../langs/zh_CN.json");
langs["zh"] = langs["zh-CN"];
langs["zh-Hans"] = langs["zh-CN"];
langs["zh-TW"] = require("../../langs/zh_TW.json");
langs["zh-Hant"] = langs["zh-TW"];

module.exports = langs;

},{"../../langs/da.json":8,"../../langs/de.json":9,"../../langs/en.json":10,"../../langs/es.json":11,"../../langs/et.json":12,"../../langs/fa.json":13,"../../langs/fi.json":14,"../../langs/hi.json":15,"../../langs/it.json":16,"../../langs/ja.json":17,"../../langs/ko.json":18,"../../langs/pl.json":19,"../../langs/pt_BR.json":20,"../../langs/ru.json":21,"../../langs/sv.json":22,"../../langs/zh_CN.json":23,"../../langs/zh_TW.json":24}],4:[function(require,module,exports){
const docIcon = `<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M3.214 1.072C4.813.752 6.916.71 8.354 2.146A.5.5 0 0 1 8.5 2.5v11a.5.5 0 0 1-.854.354c-.843-.844-2.115-1.059-3.47-.92-1.344.14-2.66.617-3.452 1.013A.5.5 0 0 1 0 13.5v-11a.5.5 0 0 1 .276-.447L.5 2.5l-.224-.447.002-.001.004-.002.013-.006a5.017 5.017 0 0 1 .22-.103 12.958 12.958 0 0 1 2.7-.869zM1 2.82v9.908c.846-.343 1.944-.672 3.074-.788 1.143-.118 2.387-.023 3.426.56V2.718c-1.063-.929-2.631-.956-4.09-.664A11.958 11.958 0 0 0 1 2.82z"/><path fill-rule="evenodd" d="M12.786 1.072C11.188.752 9.084.71 7.646 2.146A.5.5 0 0 0 7.5 2.5v11a.5.5 0 0 0 .854.354c.843-.844 2.115-1.059 3.47-.92 1.344.14 2.66.617 3.452 1.013A.5.5 0 0 0 16 13.5v-11a.5.5 0 0 0-.276-.447L15.5 2.5l.224-.447-.002-.001-.004-.002-.013-.006-.047-.023a12.582 12.582 0 0 0-.799-.34 12.96 12.96 0 0 0-2.073-.609zM15 2.82v9.908c-.846-.343-1.944-.672-3.074-.788-1.143-.118-2.387-.023-3.426.56V2.718c1.063-.929 2.631-.956 4.09-.664A11.956 11.956 0 0 1 15 2.82z"/></svg>`;
const packageIcon = `<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M8.186 1.113a.5.5 0 0 0-.372 0L1.846 3.5l2.404.961L10.404 2l-2.218-.887zm3.564 1.426L5.596 5 8 5.961 14.154 3.5l-2.404-.961zm3.25 1.7l-6.5 2.6v7.922l6.5-2.6V4.24zM7.5 14.762V6.838L1 4.239v7.923l6.5 2.6zM7.443.184a1.5 1.5 0 0 1 1.114 0l7.129 2.852A.5.5 0 0 1 16 3.5v8.662a1 1 0 0 1-.629.928l-7.185 2.874a.5.5 0 0 1-.372 0L.63 13.09a1 1 0 0 1-.63-.928V3.5a.5.5 0 0 1 .314-.464L7.443.184z"/></svg>`;
const telegramIcon = `<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path d="m 15.135036,0.00147914 c -0.01565,2.1e-5 -0.03132,4.44e-4 -0.04702,0.0013 -0.08366,0.0047 -0.167707,0.02177 -0.249133,0.05288 -7.1e-5,2.7e-5 -1.43e-4,4.3e-5 -2.14e-4,7.2e-5 L 0.55255496,5.4627331 a 0.57157718,0.57157718 0 0 0 -0.0024,9.07e-4 c -0.348213,0.133597 -0.557341,0.492923 -0.54996299977,0.819746 0.0074,0.326824 0.23249399977,0.676327 0.58638099977,0.794073 l -0.03433,-0.01263 5.93279904,2.405379 a 0.57157718,0.57157718 0 0 0 0.0337,0.01249 0.57157718,0.57157718 0 0 0 0.01256,0.03391 l 2.407542,5.9327289 -0.01074,-0.0286 c 0.120467,0.349349 0.46672,0.570238 0.791072,0.57759 0.324353,0.0074 0.680155,-0.197641 0.816328,-0.541172 a 0.57157718,0.57157718 0 0 0 0.0032,-0.0083 l 5.406976,-14.2861169 7.1e-5,-2.11e-4 c 0.124551,-0.32591496 0.02418,-0.69350296 -0.194576,-0.91225496 -0.153843,-0.153844 -0.381304,-0.249097 -0.6161,-0.248785 z M 13.352873,1.8402221 6.820368,8.3727271 1.641178,6.2728511 Z M 14.161178,2.6485271 9.729456,14.357781 7.628673,9.1810321 Z"/></svg>`;
const facebookIcon = `<svg width="1em" height="1em" viewBox="0 0 512 512" fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path d="M455.27,32H56.73A24.74,24.74,0,0,0,32,56.73V455.27A24.74,24.74,0,0,0,56.73,480H256V304H202.45V240H256V189c0-57.86,40.13-89.36,91.82-89.36,24.73,0,51.33,1.86,57.51,2.68v60.43H364.15c-28.12,0-33.48,13.3-33.48,32.9V240h67l-8.75,64H330.67V480h124.6A24.74,24.74,0,0,0,480,455.27V56.73A24.74,24.74,0,0,0,455.27,32Z"/></svg>`;

module.exports = [
  {
    id: "main",
    title: "Main",
    links: [
      {
        id: "main-site",
        icon: `<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M2 13.5V7h1v6.5a.5.5 0 0 0 .5.5h9a.5.5 0 0 0 .5-.5V7h1v6.5a1.5 1.5 0 0 1-1.5 1.5h-9A1.5 1.5 0 0 1 2 13.5zm11-11V6l-2-2V2.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5z"/>
        <path fill-rule="evenodd" d="M7.293 1.5a1 1 0 0 1 1.414 0l6.647 6.646a.5.5 0 0 1-.708.708L8 2.207 1.354 8.854a.5.5 0 1 1-.708-.708L7.293 1.5z"/>
      </svg>`,
        title: "Main site",
        url: "https://www.opensuse.org/",
      },
      {
        id: "software",
        icon: packageIcon,
        title: "Software",
        url: "https://software.opensuse.org/",
      },
      {
        id: "wiki",
        icon: `<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M14.5 3h-13a.5.5 0 0 0-.5.5v9a.5.5 0 0 0 .5.5h13a.5.5 0 0 0 .5-.5v-9a.5.5 0 0 0-.5-.5zm-13-1A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h13a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2h-13z"/>
        <path fill-rule="evenodd" d="M3 5.5a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 0 1h-9a.5.5 0 0 1-.5-.5zM3 8a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 0 1h-9A.5.5 0 0 1 3 8zm0 2.5a.5.5 0 0 1 .5-.5h6a.5.5 0 0 1 0 1h-6a.5.5 0 0 1-.5-.5z"/>
      </svg>`,
        title: "Wiki",
        url: "https://en.opensuse.org/",
      },
      {
        id: "documentation",
        icon: docIcon,
        title: "Documentation",
        url: "https://doc.opensuse.org/",
      },
      {
        id: "forum",
        icon: `<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M14 1H2a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h2.5a2 2 0 0 1 1.6.8L8 14.333 9.9 11.8a2 2 0 0 1 1.6-.8H14a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1zM2 0a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h2.5a1 1 0 0 1 .8.4l1.9 2.533a1 1 0 0 0 1.6 0l1.9-2.533a1 1 0 0 1 .8-.4H14a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/>
        <path d="M5 6a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm4 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm4 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0z"/>
      </svg>`,
        title: "Forum",
        url: "https://forums.opensuse.org/",
      },
    ],
  },
  {
    id: "development",
    title: "Development",
    links: [
      {
        id: "build-service",
        icon: `<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M8.837 1.626c-.246-.835-1.428-.835-1.674 0l-.094.319A1.873 1.873 0 0 1 4.377 3.06l-.292-.16c-.764-.415-1.6.42-1.184 1.185l.159.292a1.873 1.873 0 0 1-1.115 2.692l-.319.094c-.835.246-.835 1.428 0 1.674l.319.094a1.873 1.873 0 0 1 1.115 2.693l-.16.291c-.415.764.42 1.6 1.185 1.184l.292-.159a1.873 1.873 0 0 1 2.692 1.116l.094.318c.246.835 1.428.835 1.674 0l.094-.319a1.873 1.873 0 0 1 2.693-1.115l.291.16c.764.415 1.6-.42 1.184-1.185l-.159-.291a1.873 1.873 0 0 1 1.116-2.693l.318-.094c.835-.246.835-1.428 0-1.674l-.319-.094a1.873 1.873 0 0 1-1.115-2.692l.16-.292c.415-.764-.42-1.6-1.185-1.184l-.291.159A1.873 1.873 0 0 1 8.93 1.945l-.094-.319zm-2.633-.283c.527-1.79 3.065-1.79 3.592 0l.094.319a.873.873 0 0 0 1.255.52l.292-.16c1.64-.892 3.434.901 2.54 2.541l-.159.292a.873.873 0 0 0 .52 1.255l.319.094c1.79.527 1.79 3.065 0 3.592l-.319.094a.873.873 0 0 0-.52 1.255l.16.292c.893 1.64-.902 3.434-2.541 2.54l-.292-.159a.873.873 0 0 0-1.255.52l-.094.319c-.527 1.79-3.065 1.79-3.592 0l-.094-.319a.873.873 0 0 0-1.255-.52l-.292.16c-1.64.893-3.433-.902-2.54-2.541l.159-.292a.873.873 0 0 0-.52-1.255l-.319-.094c-1.79-.527-1.79-3.065 0-3.592l.319-.094a.873.873 0 0 0 .52-1.255l-.16-.292c-.892-1.64.902-3.433 2.541-2.54l.292.159a.873.873 0 0 0 1.255-.52l.094-.319z"/>
        <path fill-rule="evenodd" d="M8 5.754a2.246 2.246 0 1 0 0 4.492 2.246 2.246 0 0 0 0-4.492zM4.754 8a3.246 3.246 0 1 1 6.492 0 3.246 3.246 0 0 1-6.492 0z"/>
      </svg>`,
        title: "Build service",
        url: "https://build.opensuse.org/",
      },
      {
        id: "bugzilla",
        icon: `<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M4.355.522a.5.5 0 0 1 .623.333l.291.956A4.979 4.979 0 0 1 8 1c1.007 0 1.946.298 2.731.811l.29-.956a.5.5 0 1 1 .957.29l-.41 1.352A4.985 4.985 0 0 1 13 6h.5a.5.5 0 0 0 .5-.5V5a.5.5 0 0 1 1 0v.5A1.5 1.5 0 0 1 13.5 7H13v1h1.5a.5.5 0 0 1 0 1H13v1h.5a1.5 1.5 0 0 1 1.5 1.5v.5a.5.5 0 1 1-1 0v-.5a.5.5 0 0 0-.5-.5H13a5 5 0 0 1-10 0h-.5a.5.5 0 0 0-.5.5v.5a.5.5 0 1 1-1 0v-.5A1.5 1.5 0 0 1 2.5 10H3V9H1.5a.5.5 0 0 1 0-1H3V7h-.5A1.5 1.5 0 0 1 1 5.5V5a.5.5 0 0 1 1 0v.5a.5.5 0 0 0 .5.5H3c0-1.364.547-2.601 1.432-3.503l-.41-1.352a.5.5 0 0 1 .333-.623zM4 7v4a4 4 0 0 0 3.5 3.97V7H4zm4.5 0v7.97A4 4 0 0 0 12 11V7H8.5zM12 6H4a3.99 3.99 0 0 1 1.333-2.982A3.983 3.983 0 0 1 8 2c1.025 0 1.959.385 2.666 1.018A3.989 3.989 0 0 1 12 6z"/>
      </svg>`,
        title: "Bugzilla",
        url: "https://bugzilla.opensuse.org/",
      },
      {
        id: "github",
        icon: `<svg width="1em" height="1em" viewBox="0 0 512 512" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path d="M256,32C132.3,32,32,134.9,32,261.7c0,101.5,64.2,187.5,153.2,217.9a17.56,17.56,0,0,0,3.8.4c8.3,0,11.5-6.1,11.5-11.4,0-5.5-.2-19.9-.3-39.1a102.4,102.4,0,0,1-22.6,2.7c-43.1,0-52.9-33.5-52.9-33.5-10.2-26.5-24.9-33.6-24.9-33.6-19.5-13.7-.1-14.1,1.4-14.1h.1c22.5,2,34.3,23.8,34.3,23.8,11.2,19.6,26.2,25.1,39.6,25.1a63,63,0,0,0,25.6-6c2-14.8,7.8-24.9,14.2-30.7-49.7-5.8-102-25.5-102-113.5,0-25.1,8.7-45.6,23-61.6-2.3-5.8-10-29.2,2.2-60.8a18.64,18.64,0,0,1,5-.5c8.1,0,26.4,3.1,56.6,24.1a208.21,208.21,0,0,1,112.2,0c30.2-21,48.5-24.1,56.6-24.1a18.64,18.64,0,0,1,5,.5c12.2,31.6,4.5,55,2.2,60.8,14.3,16.1,23,36.6,23,61.6,0,88.2-52.4,107.6-102.3,113.3,8,7.1,15.2,21.1,15.2,42.5,0,30.7-.3,55.5-.3,63,0,5.4,3.1,11.5,11.4,11.5a19.35,19.35,0,0,0,4-.4C415.9,449.2,480,363.1,480,261.7,480,134.9,379.7,32,256,32Z"/>
        </svg>`,
        title: "GitHub",
        url: "https://github.com/opensuse",
      },
      {
        id: "openaq",
        icon: '<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M9.669.864L8 0 6.331.864l-1.858.282-.842 1.68-1.337 1.32L2.6 6l-.306 1.854 1.337 1.32.842 1.68 1.858.282L8 12l1.669-.864 1.858-.282.842-1.68 1.337-1.32L13.4 6l.306-1.854-1.337-1.32-.842-1.68L9.669.864zm1.196 1.193l-1.51-.229L8 1.126l-1.355.702-1.51.229-.684 1.365-1.086 1.072L3.614 6l-.25 1.506 1.087 1.072.684 1.365 1.51.229L8 10.874l1.356-.702 1.509-.229.684-1.365 1.086-1.072L12.387 6l.248-1.506-1.086-1.072-.684-1.365z"/><path d="M4 11.794V16l4-1 4 1v-4.206l-2.018.306L8 13.126 6.018 12.1 4 11.794z"/></svg>',
        title: "openQA",
        url: "https://openqa.opensuse.org/",
      },
      {
        id: "weblate",
        icon: `<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M1.018 7.5h2.49c.03-.877.138-1.718.312-2.5H1.674a6.958 6.958 0 0 0-.656 2.5zM2.255 4H4.09a9.266 9.266 0 0 1 .64-1.539 6.7 6.7 0 0 1 .597-.933A7.024 7.024 0 0 0 2.255 4zM8 0a8 8 0 1 0 0 16A8 8 0 0 0 8 0zm-.5 1.077c-.67.204-1.335.82-1.887 1.855-.173.324-.33.682-.468 1.068H7.5V1.077zM7.5 5H4.847a12.5 12.5 0 0 0-.338 2.5H7.5V5zm1 2.5V5h2.653c.187.765.306 1.608.338 2.5H8.5zm-1 1H4.51a12.5 12.5 0 0 0 .337 2.5H7.5V8.5zm1 2.5V8.5h2.99a12.495 12.495 0 0 1-.337 2.5H8.5zm-1 1H5.145c.138.386.295.744.468 1.068.552 1.035 1.218 1.65 1.887 1.855V12zm-2.173 2.472a6.695 6.695 0 0 1-.597-.933A9.267 9.267 0 0 1 4.09 12H2.255a7.024 7.024 0 0 0 3.072 2.472zM1.674 11H3.82a13.651 13.651 0 0 1-.312-2.5h-2.49c.062.89.291 1.733.656 2.5zm8.999 3.472A7.024 7.024 0 0 0 13.745 12h-1.834a9.278 9.278 0 0 1-.641 1.539 6.688 6.688 0 0 1-.597.933zM10.855 12H8.5v2.923c.67-.204 1.335-.82 1.887-1.855A7.98 7.98 0 0 0 10.855 12zm1.325-1h2.146c.365-.767.594-1.61.656-2.5h-2.49a13.65 13.65 0 0 1-.312 2.5zm.312-3.5h2.49a6.959 6.959 0 0 0-.656-2.5H12.18c.174.782.282 1.623.312 2.5zM11.91 4a9.277 9.277 0 0 0-.64-1.539 6.692 6.692 0 0 0-.597-.933A7.024 7.024 0 0 1 13.745 4h-1.834zm-1.055 0H8.5V1.077c.67.204 1.335.82 1.887 1.855.173.324.33.682.468 1.068z"/>
      </svg>`,
        title: "Weblate",
        url: "https://l10n.opensuse.org/",
      },
      ,
      {
        id: "kernel",
        icon: `<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M14 1H2a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1zM2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/><path fill-rule="evenodd" d="M6.854 4.646a.5.5 0 0 1 0 .708L4.207 8l2.647 2.646a.5.5 0 0 1-.708.708l-3-3a.5.5 0 0 1 0-.708l3-3a.5.5 0 0 1 .708 0zm2.292 0a.5.5 0 0 0 0 .708L11.793 8l-2.647 2.646a.5.5 0 0 0 .708.708l3-3a.5.5 0 0 0 0-.708l-3-3a.5.5 0 0 0-.708 0z"/></svg>`,
        title: "Kernel",
        url: "https://kernel.opensuse.org/",
      },
    ],
  },
  {
    id: "information",
    title: "Information",
    links: [
      {
        id: "news",
        icon: `<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M0 2A1.5 1.5 0 0 1 1.5.5h11A1.5 1.5 0 0 1 14 2v12a1.5 1.5 0 0 1-1.5 1.5h-11A1.5 1.5 0 0 1 0 14V2zm1.5-.5A.5.5 0 0 0 1 2v12a.5.5 0 0 0 .5.5h11a.5.5 0 0 0 .5-.5V2a.5.5 0 0 0-.5-.5h-11z"/>
        <path fill-rule="evenodd" d="M15.5 3a.5.5 0 0 1 .5.5V14a1.5 1.5 0 0 1-1.5 1.5h-3v-1h3a.5.5 0 0 0 .5-.5V3.5a.5.5 0 0 1 .5-.5z"/>
        <path d="M2 3h10v2H2V3zm0 3h4v3H2V6zm0 4h4v1H2v-1zm0 2h4v1H2v-1zm5-6h2v1H7V6zm3 0h2v1h-2V6zM7 8h2v1H7V8zm3 0h2v1h-2V8zm-3 2h2v1H7v-1zm3 0h2v1h-2v-1zm-3 2h2v1H7v-1zm3 0h2v1h-2v-1z"/>
      </svg>`,
        title: "News",
        url: "https://news.opensuse.org/",
      },
      {
        id: "events",
        icon: `<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path d="M6.445 11.688V6.354h-.633A12.6 12.6 0 0 0 4.5 7.16v.695c.375-.257.969-.62 1.258-.777h.012v4.61h.675zm1.188-1.305c.047.64.594 1.406 1.703 1.406 1.258 0 2-1.066 2-2.871 0-1.934-.781-2.668-1.953-2.668-.926 0-1.797.672-1.797 1.809 0 1.16.824 1.77 1.676 1.77.746 0 1.23-.376 1.383-.79h.027c-.004 1.316-.461 2.164-1.305 2.164-.664 0-1.008-.45-1.05-.82h-.684zm2.953-2.317c0 .696-.559 1.18-1.184 1.18-.601 0-1.144-.383-1.144-1.2 0-.823.582-1.21 1.168-1.21.633 0 1.16.398 1.16 1.23z"/>
        <path fill-rule="evenodd" d="M1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1zm1-3a2 2 0 0 0-2 2v11a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V3a2 2 0 0 0-2-2H2z"/>
        <path fill-rule="evenodd" d="M3.5 0a.5.5 0 0 1 .5.5V1a.5.5 0 0 1-1 0V.5a.5.5 0 0 1 .5-.5zm9 0a.5.5 0 0 1 .5.5V1a.5.5 0 0 1-1 0V.5a.5.5 0 0 1 .5-.5z"/>
      </svg>`,
        title: "Events",
        url: "https://events.opensuse.org/",
      },
      {
        id: "planet",
        icon: '<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M1.018 7.5h2.49c.03-.877.138-1.718.312-2.5H1.674a6.958 6.958 0 0 0-.656 2.5zM2.255 4H4.09a9.266 9.266 0 0 1 .64-1.539 6.7 6.7 0 0 1 .597-.933A7.024 7.024 0 0 0 2.255 4zM8 0a8 8 0 1 0 0 16A8 8 0 0 0 8 0zm-.5 1.077c-.67.204-1.335.82-1.887 1.855-.173.324-.33.682-.468 1.068H7.5V1.077zM7.5 5H4.847a12.5 12.5 0 0 0-.338 2.5H7.5V5zm1 2.5V5h2.653c.187.765.306 1.608.338 2.5H8.5zm-1 1H4.51a12.5 12.5 0 0 0 .337 2.5H7.5V8.5zm1 2.5V8.5h2.99a12.495 12.495 0 0 1-.337 2.5H8.5zm-1 1H5.145c.138.386.295.744.468 1.068.552 1.035 1.218 1.65 1.887 1.855V12zm-2.173 2.472a6.695 6.695 0 0 1-.597-.933A9.267 9.267 0 0 1 4.09 12H2.255a7.024 7.024 0 0 0 3.072 2.472zM1.674 11H3.82a13.651 13.651 0 0 1-.312-2.5h-2.49c.062.89.291 1.733.656 2.5zm8.999 3.472A7.024 7.024 0 0 0 13.745 12h-1.834a9.278 9.278 0 0 1-.641 1.539 6.688 6.688 0 0 1-.597.933zM10.855 12H8.5v2.923c.67-.204 1.335-.82 1.887-1.855A7.98 7.98 0 0 0 10.855 12zm1.325-1h2.146c.365-.767.594-1.61.656-2.5h-2.49a13.65 13.65 0 0 1-.312 2.5zm.312-3.5h2.49a6.959 6.959 0 0 0-.656-2.5H12.18c.174.782.282 1.623.312 2.5zM11.91 4a9.277 9.277 0 0 0-.64-1.539 6.692 6.692 0 0 0-.597-.933A7.024 7.024 0 0 1 13.745 4h-1.834zm-1.055 0H8.5V1.077c.67.204 1.335.82 1.887 1.855.173.324.33.682.468 1.068z"/></svg>',
        title: "Planet",
        url: "https://planet.opensuse.org/",
      },
      {
        id: "shop",
        icon: `<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M2 6v8.5a.5.5 0 0 0 .5.5h11a.5.5 0 0 0 .5-.5V6h1v8.5a1.5 1.5 0 0 1-1.5 1.5h-11A1.5 1.5 0 0 1 1 14.5V6h1zm8-5a1.5 1.5 0 0 0-1.5 1.5c0 .098.033.16.12.227.103.081.272.15.49.2A3.44 3.44 0 0 0 9.96 3h.015L10 2.999l.025.002h.014A2.569 2.569 0 0 0 10.293 3c.17-.006.387-.026.598-.073.217-.048.386-.118.49-.199.086-.066.119-.13.119-.227A1.5 1.5 0 0 0 10 1zm0 3h-.006a3.535 3.535 0 0 1-.326 0 4.435 4.435 0 0 1-.777-.097c-.283-.063-.614-.175-.885-.385A1.255 1.255 0 0 1 7.5 2.5a2.5 2.5 0 0 1 5 0c0 .454-.217.793-.506 1.017-.27.21-.602.322-.885.385a4.434 4.434 0 0 1-1.104.099H10z"/>
        <path fill-rule="evenodd" d="M6 1a1.5 1.5 0 0 0-1.5 1.5c0 .098.033.16.12.227.103.081.272.15.49.2A3.44 3.44 0 0 0 5.96 3h.015L6 2.999l.025.002h.014l.053.001a3.869 3.869 0 0 0 .799-.076c.217-.048.386-.118.49-.199.086-.066.119-.13.119-.227A1.5 1.5 0 0 0 6 1zm0 3h-.006a3.535 3.535 0 0 1-.326 0 4.435 4.435 0 0 1-.777-.097c-.283-.063-.614-.175-.885-.385A1.255 1.255 0 0 1 3.5 2.5a2.5 2.5 0 0 1 5 0c0 .454-.217.793-.506 1.017-.27.21-.602.322-.885.385a4.435 4.435 0 0 1-1.103.099H6zm1.5 12V6h1v10h-1z"/>
        <path fill-rule="evenodd" d="M15 4H1v1h14V4zM1 3a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1V4a1 1 0 0 0-1-1H1z"/>
      </svg>`,
        title: "Shop",
        url: "https://shop.opensuse.org/",
      },
      {
        id: "status",
        icon: `<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M7.938 2.016a.146.146 0 0 0-.054.057L1.027 13.74a.176.176 0 0 0-.002.183c.016.03.037.05.054.06.015.01.034.017.066.017h13.713a.12.12 0 0 0 .066-.017.163.163 0 0 0 .055-.06.176.176 0 0 0-.003-.183L8.12 2.073a.146.146 0 0 0-.054-.057A.13.13 0 0 0 8.002 2a.13.13 0 0 0-.064.016zm1.044-.45a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566z"/>
        <path d="M7.002 12a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 5.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995z"/>
      </svg>`,
        title: "Status",
        url: "https://status.opensuse.org/",
      },
      {
        id: "survey",
        icon: `<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M4 1.5H3a2 2 0 0 0-2 2V14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V3.5a2 2 0 0 0-2-2h-1v1h1a1 1 0 0 1 1 1V14a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V3.5a1 1 0 0 1 1-1h1v-1z"/>
        <path fill-rule="evenodd" d="M9.5 1h-3a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h3a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5zm-3-1A1.5 1.5 0 0 0 5 1.5v1A1.5 1.5 0 0 0 6.5 4h3A1.5 1.5 0 0 0 11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3zm4.354 7.146a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708 0l-1.5-1.5a.5.5 0 1 1 .708-.708L7.5 9.793l2.646-2.647a.5.5 0 0 1 .708 0z"/>
      </svg>`,
        title: "Survey",
        url: "https://survey.opensuse.org/",
      },
    ],
  },
  {
    id: "community",
    title: "Community",
    links: [
      {
        id: "irc-channels",
        icon: `<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M2.678 11.894a1 1 0 0 1 .287.801 10.97 10.97 0 0 1-.398 2c1.395-.323 2.247-.697 2.634-.893a1 1 0 0 1 .71-.074A8.06 8.06 0 0 0 8 14c3.996 0 7-2.807 7-6 0-3.192-3.004-6-7-6S1 4.808 1 8c0 1.468.617 2.83 1.678 3.894zm-.493 3.905a21.682 21.682 0 0 1-.713.129c-.2.032-.352-.176-.273-.362a9.68 9.68 0 0 0 .244-.637l.003-.01c.248-.72.45-1.548.524-2.319C.743 11.37 0 9.76 0 8c0-3.866 3.582-7 8-7s8 3.134 8 7-3.582 7-8 7a9.06 9.06 0 0 1-2.347-.306c-.52.263-1.639.742-3.468 1.105z"/>
        <path d="M5 8a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm4 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm4 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0z"/>
      </svg>`,
        title: "IRC channels",
        url: "https://en.opensuse.org/openSUSE:IRC_list",
      },
      {
        id: "mail-lists",
        icon: `<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M14 3H2a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4a1 1 0 0 0-1-1zM2 2a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V4a2 2 0 0 0-2-2H2z"/>
        <path d="M.05 3.555C.017 3.698 0 3.847 0 4v.697l5.803 3.546L0 11.801V12c0 .306.069.596.192.856l6.57-4.027L8 9.586l1.239-.757 6.57 4.027c.122-.26.191-.55.191-.856v-.2l-5.803-3.557L16 4.697V4c0-.153-.017-.302-.05-.445L8 8.414.05 3.555z"/>
      </svg>`,
        title: "Mail lists",
        url: "https://en.opensuse.org/openSUSE:Mailing_lists_subscription",
      },
      {
        id: "facebook-group",
        icon: facebookIcon,
        title: "Facebook group",
        url: "https://www.facebook.com/groups/opensuseproject",
      },
      {
        id: "telegram-group",
        icon: telegramIcon,
        title: "Telegram group",
        url: "https://t.me/opensuseusers",
      },
      {
        id: "reddit",
        icon: `<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 512 512" fill="currentColor"><path d="M324,256a36,36,0,1,0,36,36A36,36,0,0,0,324,256Z"/><circle cx="188" cy="292" r="36" transform="translate(-97.43 94.17) rotate(-22.5)"/><path d="M496,253.77c0-31.19-25.14-56.56-56-56.56a55.72,55.72,0,0,0-35.61,12.86c-35-23.77-80.78-38.32-129.65-41.27l22-79L363.15,103c1.9,26.48,24,47.49,50.65,47.49,28,0,50.78-23,50.78-51.21S441,48,413,48c-19.53,0-36.31,11.19-44.85,28.77l-90-17.89L247.05,168.4l-4.63.13c-50.63,2.21-98.34,16.93-134.77,41.53A55.38,55.38,0,0,0,72,197.21c-30.89,0-56,25.37-56,56.56a56.43,56.43,0,0,0,28.11,49.06,98.65,98.65,0,0,0-.89,13.34c.11,39.74,22.49,77,63,105C146.36,448.77,199.51,464,256,464s109.76-15.23,149.83-42.89c40.53-28,62.85-65.27,62.85-105.06a109.32,109.32,0,0,0-.84-13.3A56.32,56.32,0,0,0,496,253.77ZM414,75a24,24,0,1,1-24,24A24,24,0,0,1,414,75ZM42.72,253.77a29.6,29.6,0,0,1,29.42-29.71,29,29,0,0,1,13.62,3.43c-15.5,14.41-26.93,30.41-34.07,47.68A30.23,30.23,0,0,1,42.72,253.77ZM390.82,399c-35.74,24.59-83.6,38.14-134.77,38.14S157,423.61,121.29,399c-33-22.79-51.24-52.26-51.24-83A78.5,78.5,0,0,1,75,288.72c5.68-15.74,16.16-30.48,31.15-43.79a155.17,155.17,0,0,1,14.76-11.53l.3-.21,0,0,.24-.17c35.72-24.52,83.52-38,134.61-38s98.9,13.51,134.62,38l.23.17.34.25A156.57,156.57,0,0,1,406,244.92c15,13.32,25.48,28.05,31.16,43.81a85.44,85.44,0,0,1,4.31,17.67,77.29,77.29,0,0,1,.6,9.65C442.06,346.77,423.86,376.24,390.82,399Zm69.6-123.92c-7.13-17.28-18.56-33.29-34.07-47.72A29.09,29.09,0,0,1,440,224a29.59,29.59,0,0,1,29.41,29.71A30.07,30.07,0,0,1,460.42,275.1Z"/><path d="M323.23,362.22c-.25.25-25.56,26.07-67.15,26.27-42-.2-66.28-25.23-67.31-26.27h0a4.14,4.14,0,0,0-5.83,0l-13.7,13.47a4.15,4.15,0,0,0,0,5.89h0c3.4,3.4,34.7,34.23,86.78,34.45,51.94-.22,83.38-31.05,86.78-34.45h0a4.16,4.16,0,0,0,0-5.9l-13.71-13.47a4.13,4.13,0,0,0-5.81,0Z"/></svg>`,
        title: "Reddit",
        url: "https://reddit.com/r/openSUSE",
      },
    ],
  },
  {
    id: "social-media",
    title: "Social Media",
    links: [
      {
        id: "mastodon",
        icon: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 94.023018 100.80365" height="1em" width="1em"><path d="M72.57077 49.00625c-3.9125 0-7.085-3.1825-7.085-7.095 0-3.91125 3.1725-7.09375 7.085-7.09375 3.92125 0 7.09375 3.1825 7.09375 7.09375 0 3.9125-3.1725 7.095-7.09375 7.095m-25.55875 0c-3.9225 0-7.095-3.1825-7.095-7.095 0-3.91125 3.1725-7.09375 7.095-7.09375 3.91125 0 7.09375 3.1825 7.09375 7.09375 0 3.9125-3.1825 7.095-7.09375 7.095m-25.57 0c-3.91125 0-7.08375-3.1825-7.08375-7.095 0-3.91125 3.1725-7.09375 7.08375-7.09375 3.92125 0 7.09375 3.1825 7.09375 7.09375 0 3.9125-3.1725 7.095-7.09375 7.095m72.5775-15.905c0-21.86625-14.32375-28.27375-14.32375-28.27375-7.23-3.31875-19.63-4.7125-32.5175-4.8275h-.3125c-12.88875.115-25.28875 1.50875-32.5075 4.8275 0 0-14.32375 6.4075-14.32375 28.27375 0 5.00375-.105 10.995.05125 17.34C.60577 71.83 4.00702 92.905 23.78327 98.1375c9.1125 2.4125 16.945 2.9125 23.24875 2.56875 11.4225-.63375 17.84-4.07625 17.84-4.07625l-.37375-8.3025s-8.16625 2.58-17.34125 2.2675c-9.09125-.3125-18.6825-.9775-20.16-12.13875-.135-.97875-.1975-2.02875-.1975-3.13125 0 0 8.915 2.185 20.2325 2.69375 6.9075.3225 13.39875-.39375 19.98375-1.185 12.6275-1.50875 23.62375-9.29 25.0075-16.405 2.17375-11.1925 1.99625-27.3275 1.99625-27.3275" fill="currentColor"/></svg>`,
        title: "Mastodon",
        url: "https://fosstodon.org/@opensuse",
      },
      {
        id: "telegram",
        icon: telegramIcon,
        title: "Telegram",
        url: "https://t.me/opensusenews",
      },
      {
        id: "facebook",
        icon: facebookIcon,
        title: "Facebook",
        url: "https://www.facebook.com/en.openSUSE",
      },
      {
        id: "twitter",
        icon: `<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 512 512" fill="currentColor"><path d="M496,109.5a201.8,201.8,0,0,1-56.55,15.3,97.51,97.51,0,0,0,43.33-53.6,197.74,197.74,0,0,1-62.56,23.5A99.14,99.14,0,0,0,348.31,64c-54.42,0-98.46,43.4-98.46,96.9a93.21,93.21,0,0,0,2.54,22.1,280.7,280.7,0,0,1-203-101.3A95.69,95.69,0,0,0,36,130.4C36,164,53.53,193.7,80,211.1A97.5,97.5,0,0,1,35.22,199v1.2c0,47,34,86.1,79,95a100.76,100.76,0,0,1-25.94,3.4,94.38,94.38,0,0,1-18.51-1.8c12.51,38.5,48.92,66.5,92.05,67.3A199.59,199.59,0,0,1,39.5,405.6,203,203,0,0,1,16,404.2,278.68,278.68,0,0,0,166.74,448c181.36,0,280.44-147.7,280.44-275.8,0-4.2-.11-8.4-.31-12.5A198.48,198.48,0,0,0,496,109.5Z"/></svg>`,
        title: "Twitter",
        url: "https://twitter.com/opensuse",
      },
      {
        id: "youtube",
        icon: `<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 512 512" fill="currentColor"><path d="M508.64,148.79c0-45-33.1-81.2-74-81.2C379.24,65,322.74,64,265,64H247c-57.6,0-114.2,1-169.6,3.6-40.8,0-73.9,36.4-73.9,81.4C1,184.59-.06,220.19,0,255.79q-.15,53.4,3.4,106.9c0,45,33.1,81.5,73.9,81.5,58.2,2.7,117.9,3.9,178.6,3.8q91.2.3,178.6-3.8c40.9,0,74-36.5,74-81.5,2.4-35.7,3.5-71.3,3.4-107Q512.24,202.29,508.64,148.79ZM207,353.89V157.39l145,98.2Z"/></svg>`,
        title: "YouTube",
        url: "https://www.youtube.com/user/opensusetv",
      },
    ],
  },
  {
    title: "Other",
    links: [
      {
        id: "packman",
        icon: packageIcon,
        title: "Packman",
        url: "http://packman.links2linux.org/",
      },
      {
        id: "kubic",
        icon: `<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M8.186 1.113a.5.5 0 0 0-.372 0L1.846 3.5 8 5.961 14.154 3.5 8.186 1.113zM15 4.239l-6.5 2.6v7.922l6.5-2.6V4.24zM7.5 14.762V6.838L1 4.239v7.923l6.5 2.6zM7.443.184a1.5 1.5 0 0 1 1.114 0l7.129 2.852A.5.5 0 0 1 16 3.5v8.662a1 1 0 0 1-.629.928l-7.185 2.874a.5.5 0 0 1-.372 0L.63 13.09a1 1 0 0 1-.63-.928V3.5a.5.5 0 0 1 .314-.464L7.443.184z"/></svg>`,
        title: "Kubic",
        url: "https://kubic.opensuse.org/",
      },
      {
        id: "guide-unofficial",
        icon: docIcon,
        title: "Guide (unofficial)",
        url: "https://opensuse-guide.org/",
      },
      {
        id: "mirrors",
        icon: `<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path d="M4.887 5.2l-.964-.165A2.5 2.5 0 1 0 3.5 10H6v1H3.5a3.5 3.5 0 1 1 .59-6.95 5.002 5.002 0 1 1 9.804 1.98A2.501 2.501 0 0 1 13.5 11H10v-1h3.5a1.5 1.5 0 0 0 .237-2.981L12.7 6.854l.216-1.028a4 4 0 1 0-7.843-1.587l-.185.96z"/>
        <path fill-rule="evenodd" d="M5 12.5a.5.5 0 0 1 .707 0L8 14.793l2.293-2.293a.5.5 0 1 1 .707.707l-2.646 2.646a.5.5 0 0 1-.708 0L5 13.207a.5.5 0 0 1 0-.707z"/>
        <path fill-rule="evenodd" d="M8 6a.5.5 0 0 1 .5.5v8a.5.5 0 0 1-1 0v-8A.5.5 0 0 1 8 6z"/>
      </svg>`,
        title: "Mirrors",
        url: "https://mirrors.opensuse.org/",
      },
      {
        id: "lizards",
        icon: `<svg width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M2 3.5a.5.5 0 0 1 .5-.5h11a.5.5 0 0 1 0 1h-11a.5.5 0 0 1-.5-.5zm5 3a.5.5 0 0 1 .5-.5h6a.5.5 0 0 1 0 1h-6a.5.5 0 0 1-.5-.5zm0 3a.5.5 0 0 1 .5-.5h6a.5.5 0 0 1 0 1h-6a.5.5 0 0 1-.5-.5zm-5 3a.5.5 0 0 1 .5-.5h11a.5.5 0 0 1 0 1h-11a.5.5 0 0 1-.5-.5z"/>
        <path d="M3.734 6.352a6.586 6.586 0 0 0-.445.275 1.94 1.94 0 0 0-.346.299 1.38 1.38 0 0 0-.252.369c-.058.129-.1.295-.123.498h.282c.242 0 .431.06.568.182.14.117.21.29.21.521a.697.697 0 0 1-.187.463c-.12.14-.289.21-.503.21-.336 0-.577-.108-.721-.327C2.072 8.619 2 8.328 2 7.969c0-.254.055-.485.164-.692.11-.21.242-.398.398-.562.16-.168.33-.31.51-.428.18-.117.33-.213.451-.287l.211.352zm2.168 0a6.588 6.588 0 0 0-.445.275 1.94 1.94 0 0 0-.346.299c-.113.12-.199.246-.257.375a1.75 1.75 0 0 0-.118.492h.282c.242 0 .431.06.568.182.14.117.21.29.21.521a.697.697 0 0 1-.187.463c-.12.14-.289.21-.504.21-.335 0-.576-.108-.72-.327-.145-.223-.217-.514-.217-.873 0-.254.055-.485.164-.692.11-.21.242-.398.398-.562.16-.168.33-.31.51-.428.18-.117.33-.213.451-.287l.211.352z"/>
      </svg>`,
        title: "Lizards",
        url: "https://lizards.opensuse.org/",
      },
    ],
  },
];

},{}],5:[function(require,module,exports){
const langs = require("./data/langs");
const sections = require("./data/sites");
const localize = require("./util/localize");

document.addEventListener("DOMContentLoaded", function () {
  const megamenu = document.getElementById("megamenu");
  if (!megamenu) {
    return;
  }
  const content = sections
    .map(function (section) {
      const links = section.links
        .map(function (link) {
          return `<li>${link.icon} <a class="l10n" href="${link.url}" data-msg-id="${link.id}" data-url-id="${link.id}-url">${link.title}</a></li>`;
        })
        .join("");

      return `
        <div class="col-6 col-md-4 col-lg-2">
          <h5 class="megamenu-heading l10n" data-msg-id="${section.id}">${section.title}</h5>
          <ul class="megamenu-list">
            ${links}
          </ul>
        </div>
      `;
    })
    .join("");

  megamenu.innerHTML = `
    <div class="container-fluid">
      <div class="row">
        ${content}
      </div>
    </div>
  `;

  localize(".l10n", langs);
});

},{"./data/langs":3,"./data/sites":4,"./util/localize":7}],6:[function(require,module,exports){
const StickyScroller = require("sticky-scroller");

const toc = document.querySelector(".toc");

const lastIds = ["", "", "", "", ""];
const regNonWord = /[\ \-\#\/\\\.\,\"\'\:\;\[\]\{\}\&\%\$\@\!\~\+\=\<\>]+/g;
const regNumber = /^\d+/;
let showNumber = true;

if (toc) {
  new StickyScroller(toc); // scroll with the page magically

  const scope = document.querySelector(".toc-scope");

  if (scope) {
    const headings = scope.querySelectorAll(
      "h2:not(.no-toc), h3:not(.no-toc), h4:not(.no-toc), h5:not(.no-toc), h6:not(.no-toc)"
    );

    const list = [];
    let numberCounter = 0;

    headings.forEach(function(h) {
      const level = parseInt(h.tagName.substr(1)) - 2;
      linkHead(h, level);
      const item = {};
      item.link = "#" + h.id;
      item.text = h.textContent.trim();
      if (regNumber.test(item.text)) {
        numberCounter++;
      }
      pushItem(list, item, level);
    });

    // In changelog, there are already heading numbers. So we don't need to show
    // additional numbers anymore.
    showNumber = numberCounter < 5;
    const listEl = document.createElement("ul");
    toc.append(listEl);
    renderList(listEl, list);
  }
}

function linkHead(h, level) {
  if (!h.id) {
    let id = "";
    if (level > 0) {
      id += lastIds[level - 1] + "-";
    }
    id += h.textContent
      .trim()
      .toLowerCase()
      .replace(regNonWord, "-");

    h.id = id;
  }

  lastIds[level] = h.id;
}

function pushItem(list, item, level) {
  if (level === 0) {
    list.push(item);
  } else {
    if (!list.length) {
      list.push({ link: "#", text: "???" });
    }
    const parent = list[list.length - 1];
    if (!parent.children) {
      parent.children = [];
    }
    pushItem(parent.children, item, level - 1);
  }
}

function renderList(listEl, list, prefix = "") {
  list.forEach(function(item, i) {
    const itemEl = document.createElement("li");
    const linkEl = document.createElement("a");
    listEl.append(itemEl);
    itemEl.append(linkEl);
    linkEl.href = item.link;
    if (showNumber) {
      linkEl.textContent = prefix + (i + 1) + ". " + item.text;
    } else {
      linkEl.textContent = item.text;
    }

    if (item.children) {
      const childrenEl = document.createElement("ul");
      itemEl.append(childrenEl);
      renderList(childrenEl, item.children, prefix + (i + 1) + ".");
    }
  });
}

},{"sticky-scroller":1}],7:[function(require,module,exports){
function localize(selector, translations) {
  function localizeString() {
    /**
     * Detect language
     */
    var lang = document.documentElement.lang;

    if (!lang || !(lang in translations)) {
      return;
    }

    var translation = translations[lang];

    /**
     * Replace translateable string
     */
    var elements = document.querySelectorAll(selector);
    for (var i = 0; i < elements.length; i++) {
      var element = elements.item(i);
      if (element.dataset.msgId) {
        if (translation[element.dataset.msgId]) {
          element.textContent = translation[element.dataset.msgId];
          if (element.placeholder) {
            element.placeholder = translation[element.dataset.msgId];
          }
        }
      }

      if (element.dataset.urlId) {
        if (translation[element.dataset.urlId]) {
          element.setAttribute('href', translation[element.dataset.urlId]);
        }
      }
    }
  }

  localizeString();

  var observer = new MutationObserver(function (mutationsList) {
    mutationsList.map(function (mutation) {
      if (mutation.type === "attributes" && mutation.attributeName === "lang") {
        localizeString();
      }
    });
  });

  observer.observe(document.documentElement, { attributes: true });
}

module.exports = localize;

},{}],8:[function(require,module,exports){
module.exports={
    "dark-mode": "Mørk tilstand",
    "more": "Mere",
    "search": "Søgning",
    "main": "Hoved",
    "software": "Software",
    "download": "Download",
    "doc": "Dok",
    "documentation": "Dokumentation",
    "wiki": "Wiki",
    "wiki-url": "https://en.opensuse.org/",
    "forum": "Forum",
    "forum-url": "https://forums.opensuse.org/forumdisplay.php/842-English",
    "development": "Udvikling",
    "development-document": "Dokument",
    "development-document-url": "https://en.opensuse.org/Portal:Development",
    "build-service": "Byggetjeneste",
    "information": "Information",
    "news": "Nyheder",
    "release-notes": "Udgivelsesnoter",
    "events": "Begivenheder",
    "planet": "Planet",
    "shop": "Butik",
    "community": "Fællesskab",
    "connect": "Vær med",
    "facebook-group": "Facebook-gruppe",
    "mail-lists": "Mailinglister",
    "irc-channels": "IRC-kanaler",
    "social-media": "Socialemedier",
    "opensuse-universe": "openSUSE Universe",
    "main-site": "Hovedsted",
    "telegram-group": "Telegram-gruppe",
    "telegram-group-url": "https://t.me/opensuseusers",
    "other": "Andet",
    "guide-unofficial": "Vejledning (uofficiel)",
    "mirrors": "Spejle",
    "lizards": "Øgler"
}

},{}],9:[function(require,module,exports){
module.exports={
    "software": "Software",
    "download": "Download",
    "documentation": "Dokumentation",
    "wiki": "Wiki",
    "wiki-url": "https://de.opensuse.org/",
    "forum": "Forum",
    "forum-url": "https://forums.opensuse.org/forumdisplay.php/845-German",
    "development": "Entwicklung",
    "development-document": "Dokument",
    "development-document-url": "https://de.opensuse.org/Portal:Entwicklung",
    "build-service": "Build Service",
    "information": "Informationen",
    "news": "Neuigkeiten",
    "release-notes": "Versionshinweise",
    "events": "Veranstaltungen",
    "planet": "Planet",
    "shop": "Shop",
    "community": "Community",
    "connect": "Connect",
    "facebook-group": "Facebook-Gruppe",
    "google-group": "Google+-Gruppe",
    "mail-lists": "Mailinglisten",
    "irc-channels": "IRC-Kanäle",
    "social-media": "Soziale Medien",
    "dark-mode": "Dunkler Modus",
    "more": "Mehr",
    "search": "Suche",
    "main": "Main",
    "doc": "Doc",
    "opensuse-universe": "openSUSE Universum",
    "main-site": "Hauptseite",
    "telegram-group": "Telegram-Gruppe",
    "telegram-group-url": "https://t.me/opensuseusers",
    "other": "Andere",
    "guide-unofficial": "Leitfaden (inoffiziell)",
    "mirrors": "Spiegelserver",
    "lizards": "Lizards",
    "kernel": "Kernel",
    "status": "Status",
    "survey": "Umfrage"
}

},{}],10:[function(require,module,exports){
module.exports={
  "dark-mode": "Dark Mode",
  "opensuse-universe": "openSUSE Universe",
  "search": "Search",
  "main": "Main",
  "main-site": "Main site",
  "software": "Software",
  "download": "Download",
  "doc": "Doc",
  "documentation": "Documentation",
  "wiki": "Wiki",
  "wiki-url": "https://en.opensuse.org/",
  "forum": "Forum",
  "forum-url": "https://forums.opensuse.org/forumdisplay.php/842-English",
  "development": "Development",
  "development-document": "Document",
  "development-document-url": "https://en.opensuse.org/Portal:Development",
  "build-service": "Build service",
  "kernel": "Kernel",
  "information": "Information",
  "news": "News",
  "release-notes": "Release notes",
  "events": "Events",
  "planet": "Planet",
  "shop": "Shop",
  "status": "Status",
  "survey": "Survey",
  "community": "Community",
  "connect": "Connect",
  "facebook-group": "Facebook group",
  "telegram-group": "Telegram group",
  "telegram-group-url": "https://t.me/opensuseusers",
  "mail-lists": "Mail lists",
  "irc-channels": "IRC channels",
  "social-media": "Social media",
  "other": "Other",
  "guide-unofficial": "Guide (unofficial)",
  "mirrors": "Mirrors",
  "lizards": "Lizards"
}

},{}],11:[function(require,module,exports){
module.exports={
    "software": "Software",
    "download": "Descargar",
    "documentation": "Documentación",
    "wiki": "Wiki",
    "wiki-url": "https://es.opensuse.org",
    "forum": "Foro",
    "forum-url": "https://forums.opensuse.org/forumdisplay.php/837-Espa%C3%B1ol",
    "development": "Desarrollo",
    "development-document": "Documento",
    "development-document-url": "https://en.opensuse.org/Portal:Development",
    "build-service": "Servicio de compilaciones",
    "information": "Información",
    "news": "Noticias",
    "release-notes": "Informe de novedades",
    "events": "Eventos",
    "planet": "Planeta",
    "shop": "Tienda",
    "community": "Comunidad",
    "connect": "Conectar",
    "facebook-group": "Grupo de Facebook",
    "google-group": "Grupo de Google+",
    "mail-lists": "Listas de correo",
    "irc-channels": "Canales de IRC",
    "social-media": "Redes sociales",
    "dark-mode": "Modo Oscuro",
    "opensuse-universe": "Universo openSUSE",
    "search": "Buscar",
    "main": "Principal",
    "main-site": "Sitio principal",
    "doc": "Doc",
    "telegram-group": "Grupo de Telegram",
    "telegram-group-url": "https://t.me/openSUSE_ES",
    "other": "Otro",
    "guide-unofficial": "Guía (no oficial)",
    "mirrors": "Espejos",
    "lizards": "Lagartos",
    "kernel": "Kernel",
    "status": "Estado",
    "survey": "Encuesta"
}

},{}],12:[function(require,module,exports){
module.exports={
    "dark-mode": "Tume kujundus",
    "more": "Veel",
    "search": "Otsing",
    "main": "Peamine",
    "software": "Tarkvara",
    "download": "Allalaadimine",
    "doc": "Dokument",
    "documentation": "Dokumentatsioon",
    "wiki": "Wiki",
    "wiki-url": "https://en.opensuse.org/",
    "forum": "Foorum",
    "forum-url": "https://forums.opensuse.org/forum.php",
    "development": "Arendus",
    "development-document": "Dokument",
    "development-document-url": "https://en.opensuse.org/Portal:Development",
    "build-service": "Kompileerimise teenud",
    "information": "Informatsioon",
    "news": "Uudised",
    "release-notes": "Väljalaske teated",
    "events": "Sündmused",
    "planet": "Planeet",
    "shop": "Pood",
    "community": "Kommuun",
    "connect": "Ühenda",
    "facebook-group": "Facebooki grupp",
    "mail-lists": "Meililoend",
    "irc-channels": "IRC kanalid",
    "social-media": "Sotsiaalmeedia",
    "opensuse-universe": "openSUSE Universum",
    "main-site": "Esileht",
    "telegram-group": "Telegrammi grupp",
    "telegram-group-url": "https://t.me/opensuseusers",
    "other": "Muud",
    "guide-unofficial": "Juhend (mitteametlik)",
    "mirrors": "Peeglid",
    "lizards": "Lizard"
}

},{}],13:[function(require,module,exports){
module.exports={
    "dark-mode": "حالت تاریک",
    "opensuse-universe": "جهان openSUSE",
    "search": "جستجو",
    "main": "اصلی",
    "main-site": "سایت اصلی",
    "software": "نرم‌افزار",
    "download": "دریافت",
    "doc": "مستندات",
    "documentation": "مستندات",
    "wiki": "ویکی",
    "wiki-url": "https://en.opensuse.org/",
    "forum": "انجمن",
    "forum-url": "https://forums.opensuse.org/forumdisplay.php/842-English",
    "development": "توسعه",
    "development-document": "سند",
    "development-document-url": "https://en.opensuse.org/Portal:Development",
    "build-service": "سرویس ساخت",
    "information": "اطلاعات",
    "news": "اخبار",
    "release-notes": "یادداشت‌های انتشار",
    "events": "رویداد‌ها",
    "planet": "سیاره",
    "shop": "فروشگاه",
    "community": "جامعه",
    "connect": "ارتباط",
    "facebook-group": "گروه فیس‌بوک",
    "telegram-group": "گروه تلگرام",
    "telegram-group-url": "https://t.me/openSUSE_group",
    "mail-lists": "لیست ایمیل",
    "irc-channels": "کانال‌های IRC",
    "social-media": "شبکه‌های اجتماعی",
    "other": "دیگر",
    "guide-unofficial": "راهنما (غیر رسمی)",
    "mirrors": "آینه‌ها",
    "lizards": "مارمولک‌ها"
}

},{}],14:[function(require,module,exports){
module.exports={
    "dark-mode": "Tumma tila",
    "more": "Lisää",
    "search": "Etsi",
    "main": "Pääsivu",
    "software": "Ohjelmisto",
    "download": "Lataa",
    "doc": "Asiakirja",
    "documentation": "Dokumentointi",
    "wiki": "Wiki",
    "wiki-url": "https://en.opensuse.org/",
    "forum": "Foorumi",
    "forum-url": "https://forums.opensuse.org/forumdisplay.php/842-English",
    "development": "Tuotekehitys",
    "development-document": "Asiakirja",
    "development-document-url": "https://en.opensuse.org/Portal:Development",
    "build-service": "Rakenna palvelu",
    "information": "Informaatio",
    "news": "Uutiset",
    "release-notes": "Julkaisutiedot",
    "events": "Tapahtumat",
    "planet": "Planeetta",
    "shop": "Kauppa",
    "community": "Yhteisö",
    "connect": "Yhdistä",
    "facebook-group": "Facebook ryhmä",
    "mail-lists": "Postituslistat",
    "irc-channels": "IRC kanavat",
    "social-media": "Sosiaalinen media",
    "main-site": "Pääsivusto",
    "telegram-group": "Telegram ryhmä",
    "other": "Muut",
    "guide-unofficial": "Ohje (epävirallinen)",
    "mirrors": "Peilit",
    "opensuse-universe": "openSUSE-universumi",
    "telegram-group-url": "https://t.me/opensuseusers",
    "lizards": "Liskot",
    "status": "Tila",
    "survey": "Selvitys"
}

},{}],15:[function(require,module,exports){
module.exports={
    "dark-mode": "डार्क मोड",
    "opensuse-universe": "ओपनSUSE संसार",
    "search": "खोज",
    "main": "मुख्य",
    "main-site": "मुख्य साइट",
    "software": "सॉफ्टवेयर",
    "download": "डाउनलोड",
    "doc": "प्रलेख",
    "documentation": "प्रलेखन",
    "wiki": "विकी",
    "wiki-url": "https://en.opensuse.org/",
    "forum": "चर्चा मंच",
    "forum-url": "https://forums.opensuse.org/forumdisplay.php/842-English",
    "development": "सॉफ्टवेयर विकास",
    "development-document": "प्रलेख",
    "development-document-url": "https://en.opensuse.org/Portal:Development",
    "build-service": "बिल्ड सेवा",
    "kernel": "कर्नेल",
    "information": "जानकारी",
    "news": "समाचार",
    "release-notes": "प्रकाशन नोट्स",
    "events": "कार्यक्रम",
    "planet": "संसार",
    "shop": "दुकान",
    "status": "स्थिति",
    "survey": "सर्वेक्षण",
    "community": "समुदाय",
    "connect": "जुड़ें",
    "facebook-group": "फेसबुक समूह",
    "telegram-group": "टेलीग्राम समूह",
    "telegram-group-url": "https://t.me/opensuseusers",
    "mail-lists": "ईमेल सूची",
    "irc-channels": "आईआरसी चैट चैनल",
    "social-media": "सोशल मीडिया",
    "other": "अन्य",
    "guide-unofficial": "गाइड (अनाधिकारिक)",
    "mirrors": "सर्वर-मिरर",
    "lizards": "गिरगिट"
}

},{}],16:[function(require,module,exports){
module.exports={
    "dark-mode": "Modalità Scura",
    "more": "Altro",
    "search": "Cerca",
    "main": "Principale",
    "software": "Software",
    "download": "Scarica",
    "doc": "Doc",
    "documentation": "Documentazione",
    "wiki": "Wiki",
    "wiki-url": "https://it.opensuse.org/",
    "forum": "Forum",
    "forum-url": "",
    "development": "Sviluppo",
    "development-document": "Documento",
    "development-document-url": "https://it.opensuse.org/Portal:Sviluppo",
    "build-service": "Servizio di compilazione",
    "information": "Informazione",
    "news": "Novità",
    "release-notes": "Note di rilascio",
    "events": "Eventi",
    "planet": "Pianeta",
    "shop": "Negozio",
    "community": "Comunità",
    "connect": "Connetti",
    "facebook-group": "Gruppo Facebook",
    "mail-lists": "",
    "irc-channels": "Canale IRC",
    "social-media": "",
    "opensuse-universe": "Universo openSUSE",
    "main-site": "Sito principale",
    "telegram-group": "Gruppo Telegram",
    "other": "Altro",
    "guide-unofficial": "Guide (non ufficiali)"
}

},{}],17:[function(require,module,exports){
module.exports={
    "software": "ソフトウエア",
    "download": "ダウンロード",
    "documentation": "ドキュメンテーション",
    "wiki": "Wiki",
    "wiki-url": "https://ja.opensuse.org/",
    "forum": "フォーラム",
    "forum-url": "https://forum.geeko.jp/",
    "development": "開発",
    "development-document": "文書",
    "development-document-url": "https://ja.opensuse.org/Portal:%E9%96%8B%E7%99%BA",
    "build-service": "Build サービス",
    "information": "情報",
    "news": "ニュース",
    "release-notes": "リリースノート",
    "events": "イベント",
    "planet": "Planet",
    "shop": "ショップ",
    "community": "コミュニティ",
    "connect": "Connect",
    "facebook-group": "Facebook グループ",
    "google-group": "Google+ グループ",
    "mail-lists": "メーリングリスト",
    "irc-channels": "IRC チャンネル",
    "social-media": "ソーシャルメディア",
    "dark-mode": "ダークモード",
    "more": "さらに",
    "search": "検索",
    "main": "メイン",
    "doc": "文書",
    "opensuse-universe": "openSUSE Universe",
    "main-site": "メインサイト",
    "telegram-group": "Telegram グループ",
    "telegram-group-url": "https://t.me/opensuseusers",
    "other": "その他",
    "guide-unofficial": "ガイド (非公式)",
    "mirrors": "ミラー",
    "lizards": "Lizards",
    "kernel": "カーネル",
    "status": "ステータス",
    "survey": "調査"
}

},{}],18:[function(require,module,exports){
module.exports={
    "dark-mode": "",
    "more": "",
    "search": "",
    "main": "",
    "software": "",
    "download": "",
    "doc": "",
    "documentation": "",
    "wiki": "",
    "wiki-url": "",
    "forum": "",
    "forum-url": "",
    "development": "",
    "development-document": "",
    "development-document-url": "",
    "build-service": "",
    "information": "",
    "news": "",
    "release-notes": "",
    "events": "",
    "planet": "",
    "shop": "",
    "community": "",
    "connect": "",
    "facebook-group": "",
    "mail-lists": "",
    "irc-channels": "",
    "social-media": ""
}

},{}],19:[function(require,module,exports){
arguments[4][18][0].apply(exports,arguments)
},{"dup":18}],20:[function(require,module,exports){
module.exports={
    "software": "Software",
    "download": "Baixar",
    "documentation": "Documentação",
    "wiki": "Wiki",
    "wiki-url": "https://pt.opensuse.org/",
    "forum": "Fórum (apenas inglês)",
    "forum-url": "https://forums.opensuse.org/forumdisplay.php/842-English",
    "development": "Desenvolvimento",
    "development-document": "Documento",
    "development-document-url": "https://en.opensuse.org/Portal:Development",
    "build-service": "Serviço de compilação",
    "information": "Informação",
    "news": "Notícias",
    "release-notes": "Notas de lançamento",
    "events": "Eventos",
    "planet": "Planeta",
    "shop": "Loja",
    "community": "Comunidade",
    "connect": "Connect",
    "facebook-group": "Grupo no Facebook",
    "google-group": "Grupo no Google+",
    "mail-lists": "Listas de discussão",
    "irc-channels": "Canais IRC",
    "social-media": "Mídias sociais",
    "dark-mode": "Modo escuro",
    "more": "Mais",
    "search": "Pesquisa",
    "main": "Principal",
    "doc": "Doc",
    "opensuse-universe": "Universo openSUSE",
    "main-site": "Site principal",
    "telegram-group": "Grupo do Telegram",
    "telegram-group-url": "https://t.me/opensusebr",
    "other": "Outro",
    "guide-unofficial": "Guia (não-oficial)",
    "mirrors": "Espelhos",
    "lizards": "Lagartos",
    "kernel": "Kernel",
    "status": "Status",
    "survey": "Pesquisa"
}

},{}],21:[function(require,module,exports){
module.exports={
    "software": "Программное обеспечение",
    "download": "Скачать",
    "documentation": "Документация",
    "wiki": "Вики",
    "wiki-url": "https://ru.opensuse.org/",
    "forum": "Форум",
    "forum-url": "http://forums.opensuse.org/forumdisplay.php/909-P%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9-(Russian)",
    "development": "Разработка",
    "development-document": "Документ",
    "development-document-url": "https://en.opensuse.org/Portal:Development",
    "build-service": "Служба сборки",
    "information": "Информация",
    "news": "Новости",
    "release-notes": "Примечания к выпуску",
    "events": "События",
    "planet": "Планета",
    "shop": "Магазин",
    "community": "Сообщество",
    "connect": "Connect",
    "facebook-group": "Группа на Facebook",
    "google-group": "Группа в Google+",
    "mail-lists": "Списки рассылки",
    "irc-channels": "IRC-каналы",
    "social-media": "Социальные сети",
    "dark-mode": "Тёмная тема",
    "opensuse-universe": "Вселенная openSUSE",
    "search": "Поиск",
    "main": "Главная",
    "main-site": "Основной сайт",
    "doc": "Документация",
    "telegram-group": "Группа Telegram",
    "telegram-group-url": "https://t.me/opensuseusers",
    "other": "Прочее",
    "guide-unofficial": "Руководство (неофициальное)",
    "mirrors": "Зеркала",
    "lizards": "Блоги",
    "kernel": "Ядро",
    "status": "Статус",
    "survey": "Опрос"
}

},{}],22:[function(require,module,exports){
module.exports={
    "software": "Programvara",
    "download": "Ladda ner",
    "documentation": "Dokumentation",
    "wiki": "Wiki",
    "wiki-url": "https://en.opensuse.org/",
    "forum": "Forum",
    "forum-url": "https://forums.opensuse.org/forumdisplay.php/842-English",
    "development": "Utveckling",
    "development-document": "Dokument",
    "development-document-url": "https://en.opensuse.org/Portal:Development",
    "build-service": "Byggtjänst",
    "information": "Information",
    "news": "Nyheter",
    "release-notes": "Viktig information",
    "events": "Evenemang",
    "planet": "Planet",
    "shop": "Butik",
    "community": "Community",
    "connect": "Anslut",
    "facebook-group": "Facebook grupp",
    "mail-lists": "Mailinglistor",
    "irc-channels": "IRC kanaler",
    "social-media": "Social media",
    "dark-mode": "Mörkt läge",
    "opensuse-universe": "openSUSE Universumet",
    "search": "Sök",
    "main": "Huvud",
    "main-site": "Huvudsida",
    "telegram-group": "Telegram grupp",
    "telegram-group-url": "https://t.me/opensuseusers",
    "other": "Annat",
    "guide-unofficial": "Guide (inofficiell)",
    "mirrors": "Speglar",
    "lizards": "Ödlor",
    "doc": "Doc"
}

},{}],23:[function(require,module,exports){
module.exports={
    "software": "软件",
    "download": "下载",
    "documentation": "文档",
    "wiki": "维基",
    "wiki-url": "https://zh.opensuse.org/",
    "forum": "论坛",
    "forum-url": "https://forum.suse.org.cn/",
    "development": "开发",
    "development-document": "开发文档",
    "development-document-url": "https://zh.opensuse.org/Portal:%E5%BC%80%E5%8F%91",
    "build-service": "构建服务 (OBS)",
    "information": "信息",
    "news": "新闻",
    "release-notes": "发行说明",
    "events": "活动",
    "planet": "星球",
    "shop": "商店",
    "community": "社群",
    "connect": "连接",
    "facebook-group": "脸书群",
    "google-group": "Google+ 群组",
    "mail-lists": "邮件列表",
    "irc-channels": "IRC 频道",
    "social-media": "社交媒体",
    "dark-mode": "暗色模式",
    "more": "更多",
    "search": "搜索",
    "main": "主站",
    "doc": "文档",
    "opensuse-universe": "openSUSE 宇宙",
    "main-site": "主站",
    "telegram-group": "电报群",
    "telegram-group-url": "https://t.me/opensuse_cn",
    "other": "其他",
    "guide-unofficial": "指南 (非官方)",
    "mirrors": "镜像",
    "lizards": "蜥蜴部落",
    "kernel": "内核",
    "status": "状态",
    "survey": "问卷"
}

},{}],24:[function(require,module,exports){
module.exports={
    "software": "軟體",
    "download": "下載",
    "documentation": "文件",
    "wiki": "Wiki",
    "wiki-url": "https://zh-tw.opensuse.org/",
    "forum": "論壇",
    "forum-url": "https://forum.suse.org.cn/",
    "development": "開發",
    "development-document": "開發文件",
    "development-document-url": "https://en.opensuse.org/Portal:Development",
    "build-service": "建構服務 (OBS)",
    "information": "資訊",
    "news": "新聞",
    "release-notes": "發行紀錄",
    "events": "活動",
    "planet": "星球",
    "shop": "商店",
    "community": "社群",
    "connect": "連線",
    "facebook-group": "Facebook 群組",
    "google-group": "Google+ 群組",
    "mail-lists": "郵件列表",
    "irc-channels": "IRC 頻道",
    "social-media": "社群媒體",
    "dark-mode": "暗色模式",
    "more": "更多",
    "search": "搜尋",
    "main": "主要站台",
    "doc": "文件",
    "main-site": "主站",
    "kernel": "內核",
    "status": "狀態",
    "survey": "問卷",
    "telegram-group": "Telegram 群組",
    "telegram-group-url": "https://t.me/opensuseusers",
    "other": "其他",
    "guide-unofficial": "指南 (非官方)",
    "mirrors": "鏡像站台"
}

},{}]},{},[2])

//# sourceMappingURL=chameleon.js.map
