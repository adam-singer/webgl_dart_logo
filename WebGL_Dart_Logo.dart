#import('dart:html');
#import('dart:math', prefix:'Math');

#import('package:three.dart/src/ThreeD.dart');
#import('package:three.dart/src/extras/ImageUtils.dart', prefix:'ImageUtils');
#import('package:three.dart/src/extras/SceneUtils.dart', prefix:'SceneUtils');

//#import('../../src/ThreeD.dart');
//#import('../../src/extras/ImageUtils.dart', prefix:'ImageUtils');
//#import('../../src/extras/SceneUtils.dart', prefix:'SceneUtils');

class WebGLDartLogo {
  Element container;
  PerspectiveCamera camera;
  Scene scene;
  WebGLRenderer renderer;
  
  void run() {   
    init();
    animate(0);
  }
  
  void init() {
    container = new Element.tag('div');
    document.body.nodes.add( container );

    camera = new PerspectiveCamera( 45, window.innerWidth / window.innerHeight, 1, 2000 );
    camera.position.y = 300;

    scene = new Scene();
    
    scene.add( new AmbientLight( 0x404040 ) );
    var light = new DirectionalLight( 0xffffff );
    light.position.setValues( 0, 1, 0 );
    scene.add( light );

    var map = ImageUtils.loadTexture( 'textures/dart-logo.png' );
    map.wrapS = map.wrapT = Three.RepeatWrapping;
    map.anisotropy = 16;

    var materials = [
                 new MeshLambertMaterial( ambient: 0xbbbbbb, map: map, side: Three.DoubleSide ),
                 new MeshBasicMaterial( color: 0x000000, wireframe: false, transparent: true, opacity: 0.0, side: Three.DoubleSide )
                 ];

    
    var object = SceneUtils.createMultiMaterialObject( new PlaneGeometry( 100, 100, 4, 4 ), materials );
    object.position.setValues( 0, 0, 0 );
    object.rotation.x = 1;
    object.rotation.y = 0;
    object.rotation.z = 0.0;
    scene.add( object );
        
    renderer = new WebGLRenderer(); // TODO - {antialias: true}
    renderer.setSize( window.innerWidth, window.innerHeight );
    renderer.sortObjects = false;
    
    container.nodes.add( renderer.domElement );
    
    window.on.resize.add(onWindowResize);
  }
  
  onWindowResize(event) {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();

    renderer.setSize( window.innerWidth, window.innerHeight );
  }
  
  bool animate(int time) {
    window.requestAnimationFrame(animate);
    render();
  }
  
  void render() {
    var timer = new Date.now().millisecondsSinceEpoch * 0.000001 ;
    camera.position.x =  0;
    camera.lookAt( scene.position );
    scene.children.forEach((object) {
      object.rotation.y = Math.cos( timer ) * 1000;
    });

    renderer.render( scene, camera );
  }
}

void main() {
  new WebGLDartLogo().run();
}
