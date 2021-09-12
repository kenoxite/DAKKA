#include "..\control_defines.hpp"

class RscTitles
{
    class DAKKA_GUI_Dialog_Task
    {
        idd = IDC_TASK2;
        name = "Timer";
        movingEnable = false;
        enableSimulation = true;
        onLoad = "uiNamespace setVariable ['DAKKA_Dialog_Task', _this select 0];";
        onUnLoad = "uiNamespace setVariable ['DAKKA_Dialog_Task', nil]";
        duration = 9999999;
        fadeIn = 0;
        fadeOut = 0;

        class controls
        {

            class DAKKA_Txt_Task2_areaHolder: RscText
            {
                idc = IDC_TXT_TASK2_COUNTER_AREAHOLDER;

                // x = (( safeZoneX + ( safeZoneW / 2 )) - ( pixelW * pixelGridNoUIScale * -10 ));
                x = safezoneX + (safezoneW - (16 * pixelGridNoUIScale * pixelW));
                y = safezoneY + (safezoneH - (1 * pixelGridNoUIScale * pixelH));
                w = 8 * pixelGridNoUIScale * pixelW;
                h = 1 * pixelGridNoUIScale * pixelH;

                text = "Area holder:";
                colorText[] = {1,1,1,1};
                colorBackground[] = {0,0,0,0.5};
                font = GUI_FONT_MONO;
                style = ST_RIGHT;
                sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1) * 0.5;

            };

            class DAKKA_Img_Task2_Counter_areaHolder:RscPicture
            {
                idc = IDC_IMG_TASK2_COUNTER_AREAHOLDER;

                // x = (( safeZoneX + ( safeZoneW / 2 )) - ( pixelW * pixelGridNoUIScale * -20 ));
                x = safezoneX + (safezoneW - (8 * pixelGridNoUIScale * pixelW));
                y = safezoneY + (safezoneH - (1 * pixelGridNoUIScale * pixelH));
                w = 4 * pixelGridNoUIScale * pixelW;    
                h = 1 * pixelGridNoUIScale * pixelH;
                
                text = "#(rgb,8,8,3)color(1,0,0,0.5)";
            };

            class DAKKA_Txt_Task2_Counter: RscText
            {
                idc = IDC_TXT_TASK2_COUNTER_TIMER;

                // x = (( safeZoneX + ( safeZoneW / 2 )) - ( pixelW * pixelGridNoUIScale * -24 ));
                x = safezoneX + (safezoneW - (4 * pixelGridNoUIScale * pixelW));
                y = safezoneY + (safezoneH - (1 * pixelGridNoUIScale * pixelH));
                w = 4 * pixelGridNoUIScale * pixelW;
                h = 1 * pixelGridNoUIScale * pixelH;

                text = "00:00";
                colorText[] = {1,1,1,1};
                colorBackground[] = {0,0,0,0.5};
                font = GUI_FONT_MONO;
                style = ST_CENTER;
                sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1) * 0.5;

            };
        };
    };
};