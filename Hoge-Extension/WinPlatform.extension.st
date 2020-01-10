Extension { #name : #WinPlatform }

{ #category : #'*Hoge-Extension' }
WinPlatform >> userConfigDirectory [
	^ FileLocator home / 'AppData' / 'Local'
]
