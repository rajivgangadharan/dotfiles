"use strict";(globalThis.webpackChunkmomentum=globalThis.webpackChunkmomentum||[]).push([[564],{9060:(t,e,n)=>{n.d(e,{y:()=>r});var a=n(51057);class r{draw(t){const{particle:e,radius:n}=t;!function(t,e,n){const{context:r}=t,o=n.count.numerator*n.count.denominator,s=n.count.numerator/n.count.denominator,u=180*(s-2)/s,i=Math.PI-(0,a.Id)(u);if(r){r.beginPath(),r.translate(e.x,e.y),r.moveTo(0,0);for(let t=0;t<o;t++)r.lineTo(n.length,0),r.translate(n.length,0),r.rotate(i)}}(t,this.getCenter(e,n),this.getSidesData(e,n))}getSidesCount(t){const e=t.shapeData;return Math.round((0,a.Gu)(e?.sides??5))}}},20564:(t,e,n)=>{n.d(e,{TriangleDrawer:()=>r});var a=n(9060);class r extends a.y{getCenter(t,e){return{x:-e,y:e/1.66}}getSidesCount(){return 3}getSidesData(t,e){return{count:{denominator:2,numerator:3},length:2*e}}}}}]);