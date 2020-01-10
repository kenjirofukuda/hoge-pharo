Extension { #name : #UnixPlatform }

{ #category : #'*Hoge-Extension' }
UnixPlatform >> userConfigDirectory [
	^ FileLocator home / '.config'
]
