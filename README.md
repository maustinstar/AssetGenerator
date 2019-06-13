# Asset Generator

#### Xcode build phase for generating scaled assets

![sample.gif](sample.gif "Generating Assets during build.")

Xcode users know that scaling image and AppIcon assets is inefficient. Even by using tools that generate icons, precious time is spent dragging and dropping. Asset Generator is a completely automated tool that runs during your project's Build Phase. For every image and icon in .xcassets folders, Asset Generator will find the largest asset and scale it to fill any missing sizes.

## Getting Started

These instructions will show you how to implement Asset Generator as an Xcode build phase in your project.

### Adding to Xcode

1. Download the scripts folder and place it in your desired Xcode target.

2. In project settings: `Target > Build Phases > + > New Run Script Phase`

3. In the Run Script Phase, enter: `"$PROJECT_DIR"/"$PROJECT_NAME"/scripts/generateAssests.sh`

### Using in Xcode

Build your project and assets will be generated.

>For assets, you may provide any size, but you will recieve a build warning unless the largest required scale is provided.

By default, all assets will be generated from the largest asset during build. To generate only missing assets, change the contents of `generateAssets.sh` by removing the `-a` flag:

`ruby "$PROJECT_DIR"/"$PROJECT_NAME"/scripts/AssetSpec.rb -a` → `ruby "$PROJECT_DIR"/"$PROJECT_NAME"/scripts/AssetSpec.rb`

## Built With

* [Ruby](https://www.ruby-lang.org/)

## Contributing

The provided scripts are starting points for your own implementation. If you encounter bugs in the provided scripts, please report an issue.

If you have enhancements or feature requests, report an issue or create a pull request.

## Authors

* [**Michael Verges**](https://github.com/maustinstar) - *Initial work* - mverges3@gatech.edu
