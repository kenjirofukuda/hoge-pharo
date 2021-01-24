Class {
	#name : #HgOpenSettings,
	#superclass : #HgCommand,
	#category : #'Hoge-Commands'
}

{ #category : #converting }
HgOpenSettings >> asSpecCommand [
	^ super asSpecCommand
		shortcutKey: $, control;
		yourself
]

{ #category : #executing }
HgOpenSettings >> execute [
	SettingBrowser new
		changePackageSet: {
			RPackage organizer packageNamed: 'Hoge-App'. 
			RPackage organizer packageNamed: 'KFImaging' };
		open;
		expandAll
	
]

{ #category : #initialization }
HgOpenSettings >> initialize [
	super initialize.
	self name: 'Preferences ...'.
	self description: 'edit Preferences.'
]
