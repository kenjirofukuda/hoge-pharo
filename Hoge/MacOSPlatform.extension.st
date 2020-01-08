Extension { #name : #MacOSPlatform }

{ #category : #'*Hoge' }
MacOSPlatform >> userConfigDirectory [
	^ FileLocator home / '.config'
]
