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
      :git => 'git://github.com/jdp-global/CCBox2D.git',:commit => '7058f4f643372bb6ebbe2bd8f8bbce5474463654' 
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