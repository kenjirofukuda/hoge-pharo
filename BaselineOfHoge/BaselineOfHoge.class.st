Class {
	#name : #BaselineOfHoge,
	#superclass : #BaselineOf,
	#category : #BaselineOfHoge
}

{ #category : #baselines }
BaselineOfHoge >> baseline: spec [
	<baseline>
	spec for: #'pharo6.x' do: [ self baselineForPharo6: spec ].
	spec for: #'pharo8.x' do: [ self baselineForPharo8: spec ].
	spec for: #'pharo9.x' do: [ self baselineForPharo9: spec ].
]

{ #category : #baselines }
BaselineOfHoge >> baselineForCommon: spec [
	spec
		for: #common
		do: [ 
			self dependencies: spec.
			self registerPackages: spec ]
]

{ #category : #baselines }
BaselineOfHoge >> baselineForPharo6: spec [
	self baselineForCommon: spec.
	spec group: 'default' with: #('Hoge-App-Spec').
]

{ #category : #baselines }
BaselineOfHoge >> baselineForPharo8: spec [
	self baselineForCommon: spec.
	spec group: 'default' with: #('Hoge-App-Spec2').
]

{ #category : #baselines }
BaselineOfHoge >> baselineForPharo9: spec [
	self baselineForCommon: spec.
	spec group: 'default' with: #('Hoge-App-Spec2').	
]

{ #category : #accessing }
BaselineOfHoge >> customProjectAttributes [
	Smalltalk os isMacOS ifTrue: [ ^ #(#MacOS) ].
	Smalltalk os isUnix ifTrue: [ ^ #(#Unix) ].
	Smalltalk os isWindows ifTrue: [ ^ #(#Windows) ]
]

{ #category : #baselines }
BaselineOfHoge >> dependencies: spec [
	spec
		baseline: 'NeoCSV'
		with: [ spec repository: 'github://svenvc/NeoCSV/repository' ].
	spec
		baseline: 'OSWindows'
		with: [ spec repository: 'github://astares/Pharo-OS-Windows/src' ].
	spec
		baseline: 'KFImaging'
		with: [ spec repository: 'github://kenjirofukuda/imaging-pharo:master' ]
]

{ #category : #baselines }
BaselineOfHoge >> registerPackages: spec [
	spec package: 'Hoge-Extension'.
	spec
		for: #Windows
		do: [ 
			spec
				package: 'Hoge-Extension'
				with: [ spec requires: #('OSWindows') ] ].
	spec package: 'Hoge-Generic' with: [ spec requires: #('KFImaging') ].
	spec
		package: 'Hoge-App'
		with: [ spec
				requires: #('KFImaging' 'NeoCSV' 'Hoge-Generic' 'Hoge-Extension') ].
	spec package: 'Hoge-App-Spec' with: [ spec requires: #('Hoge-App') ].
	spec package: 'Hoge-App-Spec2' with: [ spec requires: #('Hoge-App') ]
]
