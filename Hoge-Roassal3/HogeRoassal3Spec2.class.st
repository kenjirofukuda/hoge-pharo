Class {
	#name : #HogeRoassal3Spec2,
	#superclass : #HogeRoassal3Spec,
	#category : #'Hoge-Roassal3'
}

{ #category : #'menu building' }
HogeRoassal3Spec2 >> subMenu [
	^ specUI newMenu
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'View Graphics';
						action: [ self cmdViewGraphics ] ].
			#('RSCanvas' 'RSCamera' 'RSAthensMorph')
				do: [ :className | 
					group
						addItem: [ :item | 
							item
								name: 'Browse ' , className;
								action: [ specUI delegate cmdBrowseClass: className asClass ] ]].
					group
						addItem: [ :item | 
							item
								name: 'Browse package';
								action: [ self class package browse ] ] ] 
]
