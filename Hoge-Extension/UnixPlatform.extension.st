Extension { #name : #UnixPlatform }

{ #category : #'*Hoge-Extension' }
UnixPlatform >> shellReveal: aFileReference [
	LibC system: ('nautilus "<1s>"' expandMacrosWith: aFileReference fullName ).
]

{ #category : #'*Hoge-Extension' }
UnixPlatform >> userConfigDirectory [
	^ FileLocator home / '.config'
]
