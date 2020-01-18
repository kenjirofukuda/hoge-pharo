Class {
	#name : #HogeAppPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'graphicsView',
		'menuItemMap',
		'menuBar',
		'delegate',
		'graphicView'
	],
	#category : #'Hoge-App-Spec2'
}

{ #category : #specs }
HogeAppPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #menuBar height: self toolbarHeight;
		add: #graphicView;
		yourself
]

{ #category : #'menu items' }
HogeAppPresenter class >> hogeMenuOn: aBuilder [
	<worldMenu>
	(aBuilder item: #Hoge2)
		order: 5.0;
		help: 'HogeApp(Spec2) open';
		action: [ self new openWithSpec ]
]

{ #category : #initialization }
HogeAppPresenter >> debugMenu [
	^ self newMenu
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Show configuration folder';
						action: [ delegate cmdShowAppConfigDir ] ] ] 
]

{ #category : #initialization }
HogeAppPresenter >> fileMenu [
	^ self newMenu
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					menuItemMap at: #settings put: item.
					item
						name: 'Settings...';
						action: [ 
							delegate cmdOpenSettings ] ] ]
]

{ #category : #initialization }
HogeAppPresenter >> initializeMenuBar [
	menuItemMap := Dictionary new.
	menuBar := self newMenuBar
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'File';
						subMenu: self fileMenu ].
			group
				addItem: [ :item | 
					item
						name: 'Debug';
						subMenu: self debugMenu ] ].
	menuBar applyTo: self
]

{ #category : #initialization }
HogeAppPresenter >> initializeWidgets [ 
	delegate := HogeAppDelegate new.
	graphicView := self newMorph.
	graphicView morph: delegate graphicViewMorph.
	self initializeMenuBar.
]

{ #category : #initialization }
HogeAppPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: delegate title.
]
