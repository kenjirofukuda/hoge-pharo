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
				with: [ spec repository: 'github://kenjirofukuda/imaging-pharo:Pharo6.1' ].
			spec
				configuration: 'WebBrowser'
				with: [ 
					spec
						versionString: #stable;
						repository: 'http://smalltalkhub.com/mc/Pharo/MetaRepoForPharo60/main' ].
			spec
				configuration: 'NeoCSV'
				with: [ 
					spec
						versionString: #stable;
						repository: 'http://mc.stfx.eu/Neo' ].
			spec package: 'Hoge-Extension'.
			spec package: 'Hoge-Generic' with: [ spec requires: #('KFImaging') ].
			spec
				package: 'Hoge-App'
				with: [ spec requires: #('KFImaging' 'NeoCSV' 'Hoge-Generic' 'Hoge-Extension') ].
			spec group: 'default' with: #('Hoge-App') ]
]
