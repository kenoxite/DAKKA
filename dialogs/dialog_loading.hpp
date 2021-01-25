#include "..\control_defines.hpp"

class DMORBAT_Loading_Screen
{

	idd = IDC_LOADING_SCREEN;
	enableSimulation = 1; // 1 (true) to allow world simulation to be running in the background, 0 to freeze it
	enableDisplay = 1; // 1 (true) to allow scene rendering in the background
	movingenable = false;

	onLoad = "";
	onUnload = "";
	onChildDestroyed = "";

	class ControlsBackground
	{
	};

	class Controls
	{
		// Loading screen
		class DMORBAT_Grp_LoadingScreen: DMORBAT_Controls_Group {
			idc = IDC_GRP_LOADINGSCREEN;	
			x = safezoneX;
			y = safezoneY;
			w = safezoneW;			
			h = safezoneH;	

			class Controls {
				class DMORBAT_Bckg_LoadingScreen:RscPicture
				{
					idc = -1;
					x = 0 * pixelGridNoUIScale * pixelW;
					y = safezoneH - (3 * pixelGridNoUIScale * pixelH);
					w = safezoneW;	
					h = 3 * pixelGridNoUIScale * pixelH;
					
					text = "#(rgb,8,8,3)color(0,0,0,0.8)";
				};
				class DMORBAT_txt_LoadingBar:DMORBAT_StaticText
				{
					idc = IDC_TXT_LOADINGSCREEN;

					x = 0 * pixelGridNoUIScale * pixelW;
					y = safezoneH - (3 * pixelGridNoUIScale * pixelH);
					w = safezoneW;	
					h = 3 * pixelGridNoUIScale * pixelH;

					text = "";
					font = GUI_FONT_BOLD;
					style = ST_CENTER;
				    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.5) * 0.5;
					colorBackground[] = {0.2,0.2,0.2,0};

					tooltip = "";
				};
			};
		};
	};	
};