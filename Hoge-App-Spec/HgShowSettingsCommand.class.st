Class {
	#name : #HgShowSettingsCommand,
	#superclass : #CmdCommand,
	#category : #'Hoge-App-Spec'
}

{ #category : #accessing }
HgShowSettingsCommand class >> shortcutActivation [
	<classAnnotation>
	CmdShortcutActivation by: $, command for: HogeApp
]

{ #category : #accessing }
HgShowSettingsCommand >> defaultMenuItemName [
	^ 'Settings...'
]
