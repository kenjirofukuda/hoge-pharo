Extension { #name : #WinPlatform }

{ #category : #'*Hoge-Extension' }
WinPlatform >> shellReveal: aFileReference [
	#WinShell
		asClassIfPresent: [ :clazz | 
			aFileReference isFile
				ifTrue: [ 
					clazz
						shellExecute: 'open'
						file: 'explorer'
						parameters: ('/select,"<1s>"' expandMacrosWith: aFileReference fullName)
						directory: ''
						show: 5 ]
				ifFalse: [ 
					clazz shellExplore: aFileReference fullName ] ]
]

{ #category : #'*Hoge-Extension' }
WinPlatform >> userConfigDirectory [
	^ FileLocator home / 'AppData' / 'Local'
]
