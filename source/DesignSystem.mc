class DesignSystem {

    private var _theme as Theme;
    private var _layout as LayoutConfig;

    function initialize() {
        _theme = new Theme();
        _layout = new LayoutConfig();
    }

    function getTheme() as Theme {
        return _theme;
    }

    function getLayout() as LayoutConfig {
        return _layout;
    }

}