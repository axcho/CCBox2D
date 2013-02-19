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
      :git => 'git://github.com/jdp-global/CCBox2D.git',:commit => 'f72a333f3f53db920a68e1cc6f5c44d31a3c096a' 
    }
    s.platform = :ios, '5.0'
    s.framework = 'Foundation', 'OpenGLES'
    
    # Linker flags
    s.requires_arc = false
    s.ios.source_files = 'CCBox2D/*.{h,mm,m}'
    s.osx.source_files = 'CCBox2D/*.{h,mm,m}'
        
end