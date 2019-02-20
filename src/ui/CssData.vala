namespace Tasks {
    public class CssData : GLib.Object {
        
        public const string SHOW_BORDER = "show_border";
        
        public const string MATERIAL_CARD = "material_card";
        public const string MATERIAL_SWITCH = "material_switch";
        public const string MATERIAL_RADIO_BUTTON = "material_radio_button";
        public const string MATERIAL_BUTTON = "material_button";
        public const string MATERIAL_FAB = "material_fab";
        public const string MATERIAL_BUTTON_FLAT = "material_button_flat";
        public const string MATERIAL_BUTTON_FLAT_COLORED = "material_button_flat_colored";
        public const string MATERIAL_BUTTON_OK = "material_button_ok";
        public const string MATERIAL_BUTTON_CANCEL = "material_button_cancel";
        public const string MATERIAL_TEXT_FIELD = "material_text_field";
        public const string MATERIAL_HINT_LABEL = "material_hint_label";
        public const string MATERIAL_HINT_ERROR = "material_hint_error";
        public const string MATERIAL_SNACKBAR = "material_snackbar";
        
        public const string MENU_ITEM = "menu_item";
        
        public const string LABEL_PRIMARY = "body2";
        public const string LABEL_SECONDARY = "body1";
        
        public const string COLOR_RADIO = "color_radio";
        
        private AppTheme theme;

        public CssData() {
            this.with_theme(new DarkTheme());
        }

        public CssData.with_theme(AppTheme theme) {
          this.theme = theme;
        }

        public string get_css_data() {
            string style = null;
            if (Gtk.get_minor_version() < 20) {
                style = "".concat(add_color("textColorPrimary", theme.get_text_primary_color()));
                style = style.concat(add_color("textColorSecondary", theme.get_text_secondary_color()));
                style = style.concat(add_color("bgColor", theme.get_bg_color()));
                style = style.concat(add_color("accentColor", theme.get_accent_color()));
                style = style.concat(add_color("accentLightColor", theme.get_accent_light_color()));
                style = style.concat(add_color("accentDarkColor", theme.get_accent_dark_color()));
                style = style.concat(add_color("accentAlphaColor", theme.get_alpha_accent_color()));
                style = style.concat(add_color("textColorDisabled", theme.get_text_disabled_color()));
                style = style.concat(add_color("cardBgColor", theme.get_card_bg_color()));
                style = style.concat(add_color("shadowColor", theme.get_shadow_color()));
                style = style.concat(add_color("shadowOutColor", theme.get_shadow_out_color()));
                style = style.concat(add_color("buttonDisabledColor", theme.get_button_disabled_color()));
                style = style.concat("""
                
                .input_field {
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: @bgColor;
                    border: 1px solid @textColorSecondary;
                    border-radius: 5px 5px 0px 0px;
                    padding: 5px;
                }
                
                .input_field:focus {
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: @accentAlphaColor;
                    border-left: 1px solid @accentAlphaColor;
                    border-top: 1px solid @accentAlphaColor;
                    border-right: 1px solid @accentAlphaColor;
                    border-bottom: 1px solid @accentColor;
                    border-radius: 5px 5px 0px 0px;
                    padding: 5px;
                }
                
                .time_label {
                    font-size: 10px;
                    color: @textColorPrimary;
                }
                
                .hint_label {
                    font-size: 10px;
                    color: @accentColor;
                }

                .mainwindow {
                    background-color: @bgColor;
                    box-shadow: #1a1a1a;
                }

                .popover {
                    background-color: @bgColor;
                    box-shadow: #1a1a1a;
                }

                .mode_label {
                    color: @textColorPrimary;
                }

                .add_button {
                    color: @textColorPrimary;
                }

                GtkTextView.view {
                    color: @textColorPrimary;
                    font-size: 11px;
                }
                
                .empty_label {
                    color: @textColorPrimary;
                    font-size: 15px;
                    background: @bgColor;
                }

                GtkTextView.view:selected {
                    color: #FFFFFF;
                    background-color: #64baff;
                    font-size: 11px;
                }
                
                 .icon_button_colored {
                    border: 1px solid transparent;
                    color: @accentColor;
                    box-shadow: none;
                    background: transparent;
                    border-radius: 5px;
                }

                .window GtkTextView,
                .window GtkHeaderBar {
                    background-color: @bgColor;
                    border-bottom-color: @bgColor;
                    box-shadow: none;
                }
                """);
            } else {
                style = "".concat(add_color("textColorPrimary", theme.get_text_primary_color()));
                style = style.concat(add_color("textColorSecondary", theme.get_text_secondary_color()));
                style = style.concat(add_color("bgColor", theme.get_bg_color()));
                style = style.concat(add_color("bgTopColor", theme.get_bg_top_color()));
                style = style.concat(add_color("bgBottomColor", theme.get_bg_bottom_color()));
                style = style.concat(add_color("accentColor", theme.get_accent_color()));
                style = style.concat(add_color("accentLightColor", theme.get_accent_light_color()));
                style = style.concat(add_color("accentDarkColor", theme.get_accent_dark_color()));
                style = style.concat(add_color("accentAlphaColor", theme.get_alpha_accent_color()));
                style = style.concat(add_color("textColorDisabled", theme.get_text_disabled_color()));
                style = style.concat(add_color("cardBgColor", theme.get_card_bg_color()));
                style = style.concat(add_color("shadowColor", theme.get_shadow_color()));
                style = style.concat(add_color("shadowOutColor", theme.get_shadow_out_color()));
                style = style.concat(add_color("buttonDisabledColor", theme.get_button_disabled_color()));
                style = style.concat("""
                
                .timer_label {
                    color: @textColorPrimary;
                    font-size: 20px;
                }
                
                .timer_view {
                    background: @accentAlphaColor;
                }
                
                .invisible_view {
                    border: 0px;
                    background: transparent;
                    color: transparent;
                    margin: 15px;
                }
                
                .invisible_view progress {
                    border: 0px;
                    background: transparent;
                    color: transparent;
                }
                
                .invisible_view pulse {
                    border: 0px;
                    background: transparent;
                    color: transparent;
                }
                
                .invisible_view selection {
                    border: 0px;
                    background: transparent;
                    color: transparent;
                }
                
                .invisible_view:focus {
                    border: 0px;
                    background: transparent;
                    color: transparent;
                    margin: 15px;
                }
                
                .before-field {
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: transparent;
                    border: 1px solid @accentLightColor;
                    border-radius: 5px 5px 0px 0px;
                    padding: 5px;
                    box-shadow: none;
                }
                
                .before-field:focus {
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: transparent;
                    border: 1px solid @accentLightColor;
                    border-radius: 5px 5px 0px 0px;
                    padding: 5px;
                    box-shadow: none;
                }
                
                .type-selector, .type-selector.box.linked {
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: transparent;
                    border: 1px solid @accentLightColor;
                    border-radius: 5px;
                    box-shadow: none;
                }
                
                .type-selector:focus, .type-selector:hover, .type-selector:hover:active {
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: transparent;
                    border: 1px solid black;
                    border-radius: 5px;
                    box-shadow: none;
                }
                
                .type-selector menu {
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: linear-gradient(@bgColor, @bgColor);
                    background-blend-mode: multiply;
                    border: 0px;
                    border-radius: 0px;
                    box-shadow: none;
                }
                
                .type-selector button:hover:active, .type-selector button:hover, .type-selector button:active {
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: @accentAlphaColor;
                    border: 1px solid @accentAlphaColor;
                    border-radius: 5px 5px 0px 0px;
                    box-shadow: none;
                }
                
                calendar:selected {
                    color: #fff;
                    background: @accentColor;
                }

                calendar {
                    color: @textColorPrimary;
                    background: transparent;
                }
                
                calendar.button {
                    color: @textColorPrimary;
                    border: 1px solid transparent;
                    box-shadow: none;
                    padding: 4px;
                    background: transparent;
                    border-radius: 5px;
                }

                calendar.button:disabled {
                    color: @textColorDisabled;
                    border: 1px solid transparent;
                    box-shadow: none;
                    padding: 4px;
                    background: transparent;
                    border-radius: 5px;
                }

                calendar.button:hover {
                    color: @textColorPrimary;
                    background: @accentAlphaColor;
                    border: 1px solid @accentAlphaColor;
                    border-radius: 5px;
                    padding: 4px;
                    box-shadow: none;
                }
                
                calendar.button:hover:active {
                    color: @textColorPrimary;
                    background: @accentAlphaColor;
                    border: 1px solid @accentAlphaColor;
                    border-radius: 5px;
                    padding: 4px;
                    box-shadow: none;
                }
                
                calendar.button:active {
                    color: @textColorPrimary;
                    border: 1px solid transparent;
                    box-shadow: none;
                    padding: 4px;
                    background: transparent;
                    border-radius: 5px;
                }
                
                spinbutton.vertical {
                    border: 0px;
                    background: transparent;
                    box-shadow: none;
                }
                
                spinbutton entry {
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: transparent;
                    border: 0px;
                    box-shadow: none;
                    border-radius: 0px;
                    padding: 5px;
                }

                spinbutton button {
                    color: @textColorPrimary;
                    border: 1px solid transparent;
                    box-shadow: none;
                    padding: 4px;
                    background: transparent;
                    border-radius: 5px;
                }

                spinbutton button:disabled {
                    color: @textColorDisabled;
                    border: 1px solid transparent;
                    box-shadow: none;
                    padding: 4px;
                    background: transparent;
                    border-radius: 5px;
                }

                spinbutton button:hover {
                    color: @textColorPrimary;
                    background: @accentAlphaColor;
                    border: 1px solid @accentAlphaColor;
                    border-radius: 5px;
                    padding: 4px;
                    box-shadow: none;
                }
                
                spinbutton button:hover:active {
                    color: @textColorPrimary;
                    background: @accentAlphaColor;
                    border: 1px solid @accentAlphaColor;
                    border-radius: 5px;
                    padding: 4px;
                    box-shadow: none;
                }
                
                spinbutton button:active {
                    color: @textColorPrimary;
                    border: 1px solid transparent;
                    box-shadow: none;
                    padding: 4px;
                    background: transparent;
                    border-radius: 5px;
                }
                
                .time_label {
                    font-size: 10px;
                    color: @textColorPrimary;
                }
                
                .time_button {
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: transparent;
                    border: 0px;
                    border-radius: 0px;
                    box-shadow: none;
                }

                .mode_label {
                    color: @textColorPrimary;
                }
                
                .moon_icon {
                    border: 0px;
                    color: @textColorPrimary;
                    box-shadow: none;
                    background: transparent;
                }
                
                .icon_button {
                    border: 1px solid transparent;
                    color: @textColorPrimary;
                    box-shadow: none;
                    background: transparent;
                    border-radius: 5px;
                }
                
                .icon_button:hover, .icon_button:hover:active  {
                    background: @accentAlphaColor;
                    border: 1px solid @accentAlphaColor;
                    border-radius: 5px;
                    color: @textColorPrimary;
                    box-shadow: none;
                }
                
                .icon_button_colored {
                    border: 1px solid transparent;
                    color: @accentLightColor;
                    box-shadow: none;
                    background: transparent;
                    border-radius: 5px;
                }
                
                .icon_button_colored:hover, .icon_button_colored:hover:active  {
                    background: @accentAlphaColor;
                    border: 1px solid @accentAlphaColor;
                    border-radius: 5px;
                    color: @accentColor;
                    box-shadow: none;
                }
                
                .body1 {
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: transparent;
                    border: 0px;
                    box-shadow: none;
                    border-radius: 0px;
                    font-weight: normal;
                }
                
                .body2 {
                    font-size: 15px;
                    color: @textColorPrimary;
                    background: transparent;
                    border: 0px;
                    box-shadow: none;
                    border-radius: 0px;
                    font-weight: bold;
                }
                
                .empty_label {
                    color: @textColorPrimary;
                    font-size: 15px;
                }
                
                .list_container {
                    background: transparent;
                }
                
                .scrollable {
                    padding: 16px;
                }
                
                .right_block {
                    background: linear-gradient(@cardBgColor, @cardBgColor);
                    background-blend-mode: multiply;
                    border-radius: 2px;
                    margin-top: 8px;
                    margin-left: 8px;
                    box-shadow: 0 1px 2px @shadowColor, 0 1px 2px @shadowOutColor;
                    transition: all 0.3s cubic-bezier(.25,.8,.25,1);
                }
                
                .material_switch {
                    border: 1px solid @buttonDisabledColor;
                    background: @buttonDisabledColor;
                }
                
                .material_switch:checked {
                    border: 1px solid @accentLightColor;
                    background: @accentLightColor;
                }
                
                .material_switch slider {
                    background: @accentColor;
                }
                
                .material_card {
                    background: linear-gradient(@cardBgColor, @cardBgColor);
                    background-blend-mode: multiply;
                    border-radius: 2px;
                    margin-top: 8px;
                    margin-left: 8px;
                    margin-right: 8px;
                    padding: 16px;
                }
                
                .material_card {
                    background: linear-gradient(@cardBgColor, @cardBgColor);
                    background-blend-mode: multiply;
                    box-shadow: 0 1px 2px @shadowColor, 0 1px 2px @shadowOutColor;
                    transition: all 0.3s cubic-bezier(.25,.8,.25,1);
                }
                
                .material_card:selected {
                    background: linear-gradient(@cardBgColor, @cardBgColor);
                    background-blend-mode: multiply;
                    box-shadow: 0 14px 28px @shadowColor, 0 10px 10px @shadowOutColor;
                }
                
                .menu_item {
                	border-radius: 0px;
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: transparent;
                    border: 0px;
                    padding: 4px;
                    box-shadow: none;
                    font-weight: normal;
                }
                
                .menu_item:hover, 
                .menu_item:hover:active,
                .menu_item:selected {
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: @accentAlphaColor;
                    border: 0px;
                    padding: 4px;
                    border-radius: 0px;
                    box-shadow: none;
                    font-weight: normal;
                }
                
                .material_button_flat, 
                .material_button_flat:hover, 
                .material_button_flat:hover:active,
                .material_button_flat:selected {
                    border-radius: 0px;
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: transparent;
                    border: 0px;
                    padding: 0px;
                    box-shadow: none;
                    font-weight: normal;
                }
                
                .material_button_flat_colored {
                    border-radius: 0px;
                    font-size: 15px;
                    color: @accentColor;
                    background: transparent;
                    border: 0px;
                    padding-top: 8px;
                    padding-bottom: 8px;
                    box-shadow: none;
                    font-weight: normal;
                } 
                .material_button_flat_colored:hover, 
                .material_button_flat_colored:hover:active,
                .material_button_flat_colored:selected {
                    border-radius: 0px;
                    font-size: 15px;
                    color: @accentColor;
                    background: @shadowColor;
                    border: 0px;
                    padding-top: 8px;
                    padding-bottom: 8px;
                    box-shadow: none;
                    font-weight: normal;
                }
                
                .material_radio_button {
                    border-radius: 0px;
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: transparent;
                    border: 0px;
                    padding: 0px;
                    margin: 5px;
                    box-shadow: none;
                    font-weight: normal;
                }
                
                .material_radio_button radio {
                    color: @accentColor;
                    border: 1px solid @accentColor;
                    background: transparent;
                }
                
                .material_fab {
                    border-radius: 25px;
                    color: #fff;
                    border: 0px;
                    padding-top: 8px;
                    padding-bottom: 8px;
                    background-color: @accentColor;
                    background-blend-mode: screen;
                    box-shadow: 0 1px 2px @shadowColor, 0 1px 2px @shadowOutColor;
                    transition: all 0.1s ease-in-out;
                }
                
                .material_fab:hover  {
                    border-radius: 25px;
                    color: #fff;
                    border: 0px;
                    padding-top: 8px;
                    padding-bottom: 8px;
                    background-color: @accentColor;
                    background-blend-mode: screen;
                    box-shadow: 0 1px 3px @shadowColor, 0 1px 3px @shadowOutColor;
                }
                
                .material_fab:selected, .material_fab:hover:active {
                    border-radius: 25px;
                    color: #fff;
                    border: 0px;
                    padding-top: 8px;
                    padding-bottom: 8px;
                    background-color: @accentColor;
                    background-blend-mode: screen;
                    box-shadow: 0 1px 4px @shadowColor, 0 1px 4px @shadowOutColor;
                }
                
                .material_fab:disabled {
                    border-radius: 25px;
                    color: @textColorDisabled;
                    border: 0px;
                    background-color: @buttonDisabledColor;
                    background-blend-mode: screen;
                    box-shadow: none;
                }
                
                .material_button {
                    border-radius: 2px;
                    color: #fff;
                    margin: 4px;
                    border: 0px;
                    padding-top: 8px;
                    padding-bottom: 8px;
                    background: linear-gradient(@accentColor, @accentColor);
                    background-blend-mode: multiply;
                    box-shadow: 0 1px 2px @shadowColor, 0 1px 2px @shadowOutColor;
                    transition: all 0.3s cubic-bezier(.25,.8,.25,1);
                }
                
                .material_button:hover  {
                    border-radius: 2px;
                    border: 0px;
                    color: #fff;
                    margin: 4px;
                    background: linear-gradient(@accentColor, @accentColor);
                    background-blend-mode: multiply;
                    box-shadow: 0 1px 3px @shadowColor, 0 1px 3px @shadowOutColor;
                }
                
                .material_button:selected, .material_button:hover:active {
                    border-radius: 2px;
                    color: #fff;
                    margin: 4px;
                    outline: 0px;
                    border: 0px;
                    background: linear-gradient(@accentColor, @accentColor);
                    background-blend-mode: multiply;
                    box-shadow: 0 1px 4px @shadowColor, 0 1px 4px @shadowOutColor;
                }
                
                .material_button:disabled {
                    border-radius: 2px;
                    color: @textColorDisabled;
                    margin: 4px;
                    border: 0px;
                    background: linear-gradient(@buttonDisabledColor, @buttonDisabledColor);
                    background-blend-mode: multiply;
                    border-radius: 5px;
                    box-shadow: none;
                }
                
                .material_text_field {
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: @accentAlphaColor;
                    border: 1px solid @accentAlphaColor;
                    border-radius: 5px 5px 0px 0px;
                    padding: 5px;
                }
                
                .material_text_field:focus {
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: @accentAlphaColor;
                    border-left: 1px solid @accentAlphaColor;
                    border-top: 1px solid @accentAlphaColor;
                    border-right: 1px solid @accentAlphaColor;
                    border-bottom: 1px solid @accentColor;
                    border-radius: 5px 5px 0px 0px;
                    padding: 5px;
                }
                
                .material_text_field:indeterminate {
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: @accentAlphaColor;
                    border-left: 1px solid @accentAlphaColor;
                    border-top: 1px solid @accentAlphaColor;
                    border-right: 1px solid @accentAlphaColor;
                    border-bottom: 1px solid red;
                    border-radius: 5px 5px 0px 0px;
                    padding: 5px;
                }
                
                .material_hint_label {
                    font-size: 10px;
                    color: @accentColor;
                    padding-left: 5px;
                }
                
                .material_hint_error {
                    font-size: 10px;
                    color: red;
                    padding-left: 5px;
                }
                
                .material_snackbar {
                    background: linear-gradient(@cardBgColor, @cardBgColor);
                    background-blend-mode: multiply;
                    padding-left: 16px;
                    padding-right: 16px;
                    padding-top: 8px;
                    padding-bottom: 8px;
                    margin-bottom: 8px;
                    margin-top: 16px;
                    margin-left: 16px;
                    margin-right: 16px;
                    border-radius: 2px;
                    box-shadow: 0 2px 2px @shadowColor, 0 2px 2px @shadowOutColor;
                    transition: all 0.3s cubic-bezier(.25,.8,.25,1);
                }
                
                .dialog-button {
                    border-radius: 0px;
                    font-size: 15px;
                    color: @accentColor;
                    background: transparent;
                    border: 0px;
                    box-shadow: none;
                    font-weight: normal;
                } 
                .dialog-button:hover, 
                .dialog-button:hover:active,
                .dialog-button:selected {
                    border-radius: 0px;
                    font-size: 15px;
                    color: @accentColor;
                    background: @shadowColor;
                    border: 0px;
                    box-shadow: none;
                    font-weight: normal;
                }
                
                .material-dialog {
                    background-color: @bgColor;
                    box-shadow: 0 1px 4px @shadowColor, 0 1px 4px @shadowOutColor;
                    border-radius: 5px;
                }
                
                .date-time-field {
                    background: @accentAlphaColor;
                    border-left: 1px solid @accentAlphaColor;
                    border-top: 1px solid @accentAlphaColor;
                    border-right: 1px solid @accentAlphaColor;
                    border-bottom: 1px solid @accentAlphaColor;
                    border-radius: 5px 5px 0px 0px;
                    padding: 5px;
                }
                
                .color_radio radio,
                .color_radio radio:checked {
                    border-color: alpha (#000, 0.3);
                    box-shadow:
                        inset 0 1px 0 0 alpha (@shadowColor, 0.7),
                        inset 0 0 0 1px alpha (@shadowColor, 0.3),
                        0 1px 0 0 alpha (@accentColor, 0.3);
                    padding: 10px;
                    -gtk-icon-shadow: none;
                }

                .color_radio radio:focus {
                    border-color: @colorAccent;
                    box-shadow:
                        inset 0 1px 0 0 alpha (@shadowColor, 0.7),
                        inset 0 0 0 1px alpha (@shadowColor, 0.3),
                        inset 0 0 0 1px alpha (@accentColor, 0.05),
                        0 1px 0 0 alpha (@accentColor, 0.3),
                        0 0 0 1px alpha (@accentColor, 0.25);
                }
                
                .color-dark radio {
                    background: #212121;
                    border-color: #0091ea;
                    color: #FFFFFF;
                }

                .color-light radio {
                    background: #eeeeee;
                    border-color: #0091ea;
                    color: #000000;
                }
                
                .color-sand radio {
                    background: #fff176;
                    border-color: #ff1744;
                    color: #000000;
                }
                
                .color-olive radio {
                    background: #a5d6a7;
                    border-color: #ff3d00;
                    color: #000000;
                }
                
                .color-grape radio {
                    background: #d1c4e9;
                    border-color: #f50057;
                    color: #000000;
                }
                
                .color-green-gradient radio {
                    background: linear-gradient(#0cebeb, #29ffc6);
                    border-color: #f50057;
                    color: #000000;
                }
                
                .color-sunset radio {
                    background: linear-gradient(#fffcdc, #d9a7c7);
                    border-color: #f50057;
                    color: #000000;
                }
                
                .show-border {
                    border: 1px solid @accentColor;
                }
                
                .mainwindow {
                    background: @bgColor;
                    box-shadow: @shadowColor;
                }
                
                .popover {
                    background: @bgColor;
                    box-shadow: @shadowColor;
                }

                .window textview.view text,
                .window headerbar {
                    background: @bgColor;
                    box-shadow: none;
                }
                """);
            }                               
            return style;
        }
        
        private string add_color(string name, string color) {
            return "@define-color ".concat(name).concat(" ").concat(color).concat(";\n");
        }
    }
}
