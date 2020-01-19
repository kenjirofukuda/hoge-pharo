Extension { #name : #RSCanvas }

{ #category : #'*Hoge-Roassal3' }
RSCanvas >> openBeforeMorphBlock: aBlock [
	| window |
	self createMorph.
	aBlock cull: morph.
	window := morph openInWindow.
	morph privateOwner: window.
	^ window
	
]
