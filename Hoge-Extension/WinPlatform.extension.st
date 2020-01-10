Extension { #name : #WinPlatform }

{ #category : #'*Hoge-Extension' }
WinPlatform >> shellReveal: aFileReference [
	aFileReference isFile
		ifTrue: [ 
			#OSProcess
				asClassIfPresent: [ :clazz | 
					clazz command: ('explorer.exe /select,"<1s>"' expandMacrosWith: aFileReference fullName) ] ]
		ifFalse: [ #(#NBWin32Shell #WinShell)
				do: [ :each | each asClassIfPresent: [ :clazz | ^ clazz shellExplore: aFileReference fullName ] ] ]
]

{ #category : #'*Hoge-Extension' }
WinPlatform >> userConfigDirectory [
	^ FileLocator home / 'AppData' / 'Local'
]
