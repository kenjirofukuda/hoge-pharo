Extension { #name : #WinPlatform }

{ #category : #'*Hoge' }
WinPlatform >> userConfigDirectory [
	^ FileLocator home / 'AppData' / 'Local'
]
