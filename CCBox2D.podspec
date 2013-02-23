Pod::Spec.new do |s|
    s.name = 'CCBox2D'
    s.version = '0.0.1'
    s.summary = 'CCBox2D is a cocos2d-flavored wrapper for Box2D, written by axcho on behalf of Fugazo, Inc.'
    s.homepage = 'https://github.com/jdp-global/CCBox2D'
    s.license = {
      :type => 'MIT',
      :file => 'License.txt'
    }
    s.author = {'axcho' => 'axcho@axcho.com/'}
    s.source = { 
      :git => 'git://github.com/jdp-global/CCBox2D.git',:commit => 'b43d018ef1af2162c12f5fe115876be42b1a893c' 
    }
    s.platform = :ios, '5.0'
    s.framework = 'Foundation', 'OpenGLES'
    
    # Linker flags
    s.requires_arc = false
    s.ios.source_files = 'CCBox2D/*.{h,m,mm,cpp}'
    s.osx.source_files = 'CCBox2D/*.{h,m,mm,cpp}'
        
	s.dependency 'cocos2d'
	s.dependency 'box2d'
end