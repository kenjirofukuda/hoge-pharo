Class {
	#name : #BaselineOfHoge,
	#superclass : #BaselineOf,
	#category : #BaselineOfHoge
}

{ #category : #baselines }
BaselineOfHoge >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			spec
				baseline: 'KFImaging'
				with: [ 
					spec repository: 'github://kenjirofukuda/imaging-pharo:Pharo6.1' ].
			spec
				configuration: 'NeoCSV'
				with: [ spec
						versionString: #stable;
						repository: 'http://mc.stfx.eu/Neo' ].
			spec
				baseline: 'OSWindows'
				with: [ 
					spec repository: 'github://astares/Pharo-OS-Windows/src' ].	
			spec package: 'Hoge-Extension'.
			spec
				for: #Windows
				do: [ 
					spec package: 'Hoge-Extension' with: [ spec requires: #('OSWindows') ] ].
			spec package: 'Hoge-Generic' with: [ spec requires: #('KFImaging') ].
			spec
				package: 'Hoge-App'
				with: [ 
					spec requires: #('KFImaging' 'NeoCSV' 'Hoge-Generic' 'Hoge-Extension') ].
			spec
				package: 'Hoge-App-Spec'
				with: [ 
					spec requires: #('Hoge-App') ].
			spec group: 'default' with: #('Hoge-App-Spec') ]
]

{ #category : #accessing }
BaselineOfHoge >> customProjectAttributes [
	Smalltalk os isMacOS ifTrue: [ ^ #(#MacOS) ].
	Smalltalk os isUnix ifTrue: [ ^ #(#Unix) ].
	Smalltalk os isWindows ifTrue: [ ^ #(#Windows) ]
]
