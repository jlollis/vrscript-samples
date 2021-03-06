#lang racket/base
(require "vr.rkt")


; Shaders can be defined at any time, then referenced with a shader parm on a surface.
(+shader "testshader" 
"
uniform highp mat4 Mvpm;
attribute highp vec4 Position;
attribute highp vec2 TexCoord;
varying highp vec2 oTexCoord;
void main()
{
  oTexCoord = TexCoord;
  gl_Position = Mvpm * Position;
}
"
; https://www.shadertoy.com/view/ldBGRR
"
varying highp vec2 oTexCoord;
uniform highp vec4 UniformColor;
void main()
{
highp vec2 p = -1.0 + 2.0 * oTexCoord.xy;
highp float iGlobalTime = UniformColor.x;
// main code, *original shader by: 'Plasma' by Viktor Korsun (2011)
highp float x = p.x;
highp float y = p.y;
highp float mov0 = x+y+cos(sin(iGlobalTime)*2.0)*100.+sin(x/100.)*1000.;
highp float mov1 = y / 0.9 +  iGlobalTime;
highp float mov2 = x / 0.2;
highp float c1 = abs(sin(mov1+iGlobalTime)/2.+mov2/2.-mov1-mov2+iGlobalTime);
highp float c2 = abs(sin(c1+sin(mov0/1000.+iGlobalTime)+sin(y/40.+iGlobalTime)+sin((x+y)/100.)*3.));
highp float c3 = abs(sin(c2+cos(mov1+mov2+c2)+cos(mov2)+sin(x/1000.)));
gl_FragColor = vec4(c1,c2,c3,1);
}
")

(define (frame)
  (+pano "http://s3.amazonaws.com/o.oculuscdn.com/v/test/social/avatars/office_john.JPG")
  (+quad "_white" 
             (mat4-translate -0.5 -0.45 -2.0) 
             (opt-parm (input-time *input*) 0.0 0.5 0.0)
             (opt-shader "testshader")))

(vrmain "172.22.52.41" frame)
