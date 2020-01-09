Extension { #name : #UnixPlatform }

{ #category : #'*Hoge' }
UnixPlatform >> userConfigDirectory [
	^ FileLocator home / '.config'
]
