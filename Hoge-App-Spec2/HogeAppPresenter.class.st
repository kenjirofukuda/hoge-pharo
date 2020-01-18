Class {
	#name : #HogeAppPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'graphicsView'
	],
	#category : #'Hoge-App-Spec2'
}

{ #category : #specs }
HogeAppPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #graphicsView;
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
HogeAppPresenter >> initializeWidgets [ 
	graphicsView := self newMorph.
	graphicsView morph: HgGraphicViewMorph new.
]

{ #category : #initialization }
HogeAppPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'Points View'.
]
