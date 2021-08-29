#include "..\control_defines.hpp"

class DMORBAT_Menu_Mission_Edit
{

	idd = IDC_MENU_MISSION_EDIT;
	enableSimulation = 1; // 1 (true) to allow world simulation to be running in the background, 0 to freeze it
	enableDisplay = 1; // 1 (true) to allow scene rendering in the background
	movingenable = false;

	onLoad = "";
	onUnload = "";
	onChildDestroyed = "";

	class ControlsBackground
	{

        // ---- MAPS ----

		class DMORBAT_AOselectionMapTerrain:DMORBAT_Map
		{
			idc = IDC_MAP_AO_SEL_T;

			x = safezoneX + (20 * pixelGridNoUIScale * pixelW);
			y = safezoneY + (11 * pixelGridNoUIScale * pixelH);
			w = (safezoneW - (20 * pixelGridNoUIScale * pixelW));
			h = (SafeZoneH - (27 * pixelGridNoUIScale * pixelH));

			maxSatelliteAlpha = 0;
			alphaFadeStartScale = 0;
			alphaFadeEndScale = 0;
			drawShaded = 0.25;
			drawObjects = 0;
			colorOutside[] = {0.2,0.2,0.2,1};
            class Bush
            {
                color[] = {0.45,0.64,0.33,0};
                icon = "";
                size = "14/2";
                importance = "0.2 * 14 * 0.05 * 0.05";
                coefMin = 0.25;
                coefMax = 4;
            };
		};

		class DMORBAT_AOselectionMapSatellite:DMORBAT_Map
		{
			idc = IDC_MAP_AO_SEL_S;

			x = safezoneX + (20 * pixelGridNoUIScale * pixelW);
			y = safezoneY + (11 * pixelGridNoUIScale * pixelH);
			w = (safezoneW - (20 * pixelGridNoUIScale * pixelW));
			h = (SafeZoneH - (27 * pixelGridNoUIScale * pixelH));

			maxSatelliteAlpha = 1.0;
			alphaFadeStartScale = 2;
			alphaFadeEndScale = 2;
			ptsPerSquareSea = 2.5;
			drawShaded = 0.3;
			drawObjects = 0;
			colorCountlines[] = {1,1,1,0};
			colorMainCountlines[] = {1,1,1,0};
			colorLevels[] = {1,1,1,0.35};
			colorNames[] = {1,1,1,0.35};
			colorOutside[] = {0.2,0.2,0.2,1};
            class Bush
            {
                color[] = {0.45,0.64,0.33,0};
                icon = "";
                size = "14/2";
                importance = "0.2 * 14 * 0.05 * 0.05";
                coefMin = 0.25;
                coefMax = 4;
            };
		};

        // ---- MENU BACKGROUNDS ----

		// Left bar background
		class DMORBAT_Grp_LeftBarBckg: RscControlsGroupNoScrollbars {
			idc = IDC_GRP_LEFTBAR_BCKG;	

			x = SafeZoneX + (0 * pixelGridNoUIScale * pixelW);
			y = SafeZoneY + (0 * pixelGridNoUIScale * pixelH);
			w = (20 * pixelGridNoUIScale * pixelW);
			h = safezoneH;

			class Controls {
				class DMORBAT_FactionGroupsSelectionBckg:RscPicture
				{
					idc = IDC_BCKG_LEFTBAR_BCKG1;
					x = 0 * pixelGridNoUIScale * pixelW;
					y = 0 * pixelGridNoUIScale * pixelH;
					w = 20 * pixelGridNoUIScale * pixelW;	
					h = safezoneH;
					
					text = "#(rgb,8,8,3)color(0.3,0.3,0.3,1)";
				};

				class DMORBAT_FactionGroupsSelectionBckgHStrip1:RscPicture
				{
					idc = IDC_BCKG_LEFTBAR_BCKG_HSTRIP1;
					x = 0 * pixelGridNoUIScale * pixelW;
					y = 0 * pixelGridNoUIScale * pixelH;
					w = (20 * pixelGridNoUIScale * pixelW);		
					h = 3 * pixelGridNoUIScale * pixelH;
					
					text = "#(rgb,8,8,3)color(1,0.5,0,1)";
				};

				class DMORBAT_FactionGroupsSelectionBckgHStrip2:RscPicture
				{
					idc = IDC_BCKG_LEFTBAR_BCKG_HSTRIP2;
					x = 0 * pixelGridNoUIScale * pixelW;
					y = 5 * pixelGridNoUIScale * pixelH;
					w = 20 * pixelGridNoUIScale * pixelW;	
					h = 0.5 * pixelGridNoUIScale * pixelH;
					
					text = "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
				};

				class DMORBAT_Bckg_FactionGroupsSelectionVStrip1:RscPicture
				{
					idc = IDC_BCKG_LEFTBAR_BCKG_VSTRIP1;
					x = 0 * pixelGridNoUIScale * pixelW;
					y = 5 * pixelGridNoUIScale * pixelH;
					w = 2 * pixelGridNoUIScale * pixelW;	
					h = safezoneH - (5 * pixelGridNoUIScale * pixelH);
					
					text = "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
				};

				class DMORBAT_Bckg_FactionGroupsSelectionVStrip2:RscPicture
				{
					idc = IDC_BCKG_LEFTBAR_BCKG_VSTRIP2;
					x = (19.499 * pixelGridNoUIScale * pixelW);
					y = 5 * pixelGridNoUIScale * pixelH;
					w = 0.5 * pixelGridNoUIScale * pixelW;	
					h = safezoneH - (20.5 * pixelGridNoUIScale * pixelH);
					
					text = "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
				};

				class DMORBAT_Bckg_FactionGroupsSelectionBottom:RscPicture
				{
					idc = IDC_BCKG_LEFTBAR_BCKG_BOTTOM;
					x = 2 * pixelGridNoUIScale * pixelW;
					y = (SafeZoneH - (16 * pixelGridNoUIScale * pixelH));
					w = 18 * pixelGridNoUIScale * pixelW;
					h = (16 * pixelGridNoUIScale * pixelH);
					
					text = "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
				};

				class DMORBAT_Bckg_FactionGroupsSelectionMsg:RscPicture
				{
					idc = IDC_BCKG_LEFTBAR_BCKG_MSG;
					x = 2 * pixelGridNoUIScale * pixelW;
					y = (SafeZoneH - (8 * pixelGridNoUIScale * pixelH));
					w = 17 * pixelGridNoUIScale * pixelW;
					h = (5.4 * pixelGridNoUIScale * pixelH);
					
					text = "#(rgb,8,8,3)color(0.3,0.3,0.3,0.5)";
				};

			};
		};

		// Bottom bar background
		class DMORBAT_Grp_BottomBarBckg: DMORBAT_Controls_Group {
			idc = IDC_GRP_BOTTOMBAR_BCKG;	
	
			x = safezoneX + (20 * pixelGridNoUIScale * pixelW);
			y = SafeZoneY + (SafeZoneH - (16 * pixelGridNoUIScale * pixelH));
			w = (safezoneW - (20 * pixelGridNoUIScale * pixelW));
			h = safezoneY + (SafeZoneH - (16 * pixelGridNoUIScale * pixelH));

			class Controls {
				class DMORBAT_FactionGroupsSelectionBckg:RscPicture
				{
					idc = IDC_BCKG_BOTTOMBAR_BCKG1;
					x = 0 * pixelGridNoUIScale * pixelW;
					y = 0 * pixelGridNoUIScale * pixelH;
					w = (safezoneW - (20 * pixelGridNoUIScale * pixelW));	
					h = 16 * pixelGridNoUIScale * pixelH;
					
					text = "#(rgb,8,8,3)color(0.3,0.3,0.3,1)";
				};
				class DMORBAT_FactionGroupsSelectionBckgHStrip1:RscPicture
				{
					idc = IDC_BCKG_BOTTOMBAR_HSTRIP1;
					x = 0 * pixelGridNoUIScale * pixelW;
					y = 0 * pixelGridNoUIScale * pixelH;
					w = (safezoneW - (20 * pixelGridNoUIScale * pixelW));	
					h = 0.5 * pixelGridNoUIScale * pixelH;
					
					text = "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
				};
				class DMORBAT_FactionGroupsSelectionBckgHStrip2:RscPicture
				{
					idc = IDC_BCKG_BOTTOMBAR_HSTRIP2;
					x = 0 * pixelGridNoUIScale * pixelW;
					y = 0.5 * pixelGridNoUIScale * pixelH;
					w = (safezoneW - (20 * pixelGridNoUIScale * pixelW));
					h = 1.5 * pixelGridNoUIScale * pixelH;
					
					text = "#(rgb,8,8,3)color(1,0.5,0,1)";
				};

			};
		};

        // ---- PREVIEW AREA ----

        class DMORBAT_BT_PreviewArea:DMORBAT_InvisibleButton
        {
            idc = IDC_BT_PREVIEW;

            x = safezoneX + (20 * pixelGridNoUIScale * pixelW);
            y = safezoneY + (11 * pixelGridNoUIScale * pixelH);
            w = (safezoneW - (20 * pixelGridNoUIScale * pixelW));
            h = (SafeZoneH - (27 * pixelGridNoUIScale * pixelH));
        };
	};

	class Controls
	{

		// Main menu
		class DMORBAT_Grp_MainMenu: DMORBAT_Controls_Group {
			idc = IDC_GRP_MAINMENU;	

			x = (safeZoneX + ( safeZoneWAbs / 2 )) - ((20 * pixelGridNoUIScale * pixelW) / 2 );
			y = SafeZoneY + (0 * pixelGridNoUIScale * pixelH);
			w = (25 * pixelGridNoUIScale * pixelW);
			h = safezoneH;

			class Controls {
				class DMORBAT_Bckg_MainMenu:RscPicture
				{
					idc = -1;
					x = 0 * pixelGridNoUIScale * pixelW;
					y = 0 * pixelGridNoUIScale * pixelH;
					w = 25 * pixelGridNoUIScale * pixelW;	
					h = safezoneH;
					
					text = "#(rgb,8,8,3)color(0,0,0,0.5)";
				};

				class DMORBAT_Grp_MainMenuElements: DMORBAT_Controls_Group {
					idc = IDC_GRP_MAINMENU_ELEMENTS;	

					x = (0 * pixelGridNoUIScale * pixelW);
					y = (0 * pixelGridNoUIScale * pixelH);
					w = (25 * pixelGridNoUIScale * pixelW);
					h = safezoneH;

					class Controls {
						class DMORBAT_Title_MainMenu:DMORBAT_StaticText
						{
							idc = IDC_MM_TITLE;

							x = 0 * pixelGridNoUIScale * pixelW;
							y = 3 * pixelGridNoUIScale * pixelH;
							w = 25 * pixelGridNoUIScale * pixelW;	
							h = 10 * pixelGridNoUIScale * pixelH;

							colorText[] = {1,1,1,1};
							colorBackground[] = {0.2,0.2,0.2,0};
							text = "";
							font = GUI_FONT_BOLD;
							style = ST_CENTER + ST_MULTI;
						    sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 4) * 0.5;
						    lineSpacing = 0.6;
							tooltip = "";
						};

                        // Task selection
						class DMORBAT_Title_MainMenu_TaskSelection:DMORBAT_StaticText
						{
							idc = -1;

							x = 4 * pixelGridNoUIScale * pixelW;
							y = 15 * pixelGridNoUIScale * pixelH;
							w = 17 * pixelGridNoUIScale * pixelW;	
							h = 2 * pixelGridNoUIScale * pixelH;	

							colorText[] = {1,1,1,1};
							colorBackground[] = {0.2,0.2,0.2,0};
							text = "Choose a Task:";
							font = GUI_FONT_MONO;
							style = ST_CENTER + ST_MULTI;
						    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
							tooltip = "";
						};
						
						class DMORBAT_Bckg_MainMenu_TaskSelection:RscPicture
						{
							idc = -1;

							x = (2 * pixelGridNoUIScale * pixelW);
							y = (17 * pixelGridNoUIScale * pixelH);
							w = (21 * pixelGridNoUIScale * pixelW);	
							h = (28 * pixelGridNoUIScale * pixelH);
							
							text = "#(rgb,8,8,3)color(0.3,0.3,0.3,0.5)";
						};

						class DMORBAT_XListB_MainMenu_TaskSelection:DMORBAT_XListBox
						{
							idc = IDC_XLISTBOX_TITLE;

							x = 2 * pixelGridNoUIScale * pixelW;
							y = 17 * pixelGridNoUIScale * pixelH;
							w = 21 * pixelGridNoUIScale * pixelW;	
							h = 2 * pixelGridNoUIScale * pixelH;
							
							font = GUI_FONT_BOLD;
							colorText[] = {1,1,1,1};
							colorSelect[] = {1,1,1,1}; // Selected text color
						    sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
							tooltip = "";
						};

						class DMORBAT_Img_MainMenu_TaskSelection_Desc:RscPicture
						{
							idc = IDC_MM_TASK_IMG;

							x = 4 * pixelGridNoUIScale * pixelW;
							y = 21 * pixelGridNoUIScale * pixelH;
							w = 17 * pixelGridNoUIScale * pixelW;	
							h = 8.5 * pixelGridNoUIScale * pixelH;
							
							text = "";
							colorBackground[] = {0,0,0,1};
							colorText[] = {1,1,1,1};
						};
						
						class DMORBAT_Bckg_MainMenu_TaskSelection_Desc:RscPicture
						{
							idc = -1;

							x = (4 * pixelGridNoUIScale * pixelW);
							y = (27 * pixelGridNoUIScale * pixelH);
							w = (17 * pixelGridNoUIScale * pixelW);	
							h = (2.5 * pixelGridNoUIScale * pixelH);
							
							text = "#(rgb,8,8,3)color(0.2,0.2,0.2,0.5)";
						};

						class DMORBAT_Txt_MainMenu_TaskSelection_Desc:DMORBAT_StaticText
						{
							idc = IDC_MM_TASK_DESC;

							x = 4 * pixelGridNoUIScale * pixelW;
							y = 27.2 * pixelGridNoUIScale * pixelH;
							w = 17 * pixelGridNoUIScale * pixelW;	
							h = 2 * pixelGridNoUIScale * pixelH;

							colorText[] = {1,1,1,1};
							colorBackground[] = {0.2,0.2,0.2,0};
							text = "";
							font = GUI_FONT_MONO;
							style = ST_CENTER + ST_MULTI;
						    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1) * 0.5;
						    lineSpacing = 0.8;

							tooltip = "";
						};

						class DMORBAT_Title_MainMenu_PlayerFaction:DMORBAT_StaticText
						{
							idc = -1;

							x = 4 * pixelGridNoUIScale * pixelW;
							y = 31 * pixelGridNoUIScale * pixelH;
							w = 17 * pixelGridNoUIScale * pixelW;	

                            colorText[] = {1,1,1,1};
                            colorBackground[] = {0.2,0.2,0.2,0};
							text = "Player Faction:";
							font = GUI_FONT_MONO;
							style = ST_CENTER + ST_MULTI;
						    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
							tooltip = "";
						};

						class DMORBAT_Combo_MainMenu_PlayerFaction:DMORBAT_Combo
						{
							idc = IDC_COMBO_FACTIONS_PLAYER;

							x = 4 * pixelGridNoUIScale * pixelW;
							y = 33 * pixelGridNoUIScale * pixelH;
							w = 17 * pixelGridNoUIScale * pixelW;
							h = 2 * pixelGridNoUIScale * pixelH;

							sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.5) * 0.5;	
							rowHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 1) * 0.5;
							wholeHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 25) * 0.5;
							tooltip = "";
						};

						class DMORBAT_Title_MainMenu_EnemyFaction:DMORBAT_StaticText
						{
							idc = -1;
							access = 0;

							x = 4 * pixelGridNoUIScale * pixelW;
							y = 36 * pixelGridNoUIScale * pixelH;
							w = 17 * pixelGridNoUIScale * pixelW;	

                            colorText[] = {1,1,1,1};
                            colorBackground[] = {0.2,0.2,0.2,0};
							text = "Enemy Faction:";
							font = GUI_FONT_MONO;
							style = ST_CENTER + ST_MULTI;
						    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
							tooltip = "";
						};

						class DMORBAT_Combo_MainMenu_EnemyFaction:DMORBAT_Combo
						{
							idc = IDC_COMBO_FACTIONS_ENEMY;

							x = 4 * pixelGridNoUIScale * pixelW;
							y = 38 * pixelGridNoUIScale * pixelH;
							w = 17 * pixelGridNoUIScale * pixelW;
							h = 2 * pixelGridNoUIScale * pixelH;

							sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.5) * 0.5;	
							rowHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 1) * 0.5;
							wholeHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 25) * 0.5;
							tooltip = "";
						};

						class DMORBAT_BT_MainMenu_Edit:DMORBAT_Button
						{
							idc = IDC_BT_GROUP_SEL;

							x = 8 * pixelGridNoUIScale * pixelW;
							y = 41 * pixelGridNoUIScale * pixelH;
							w = 10 * pixelGridNoUIScale * pixelW;
							h = 2 * pixelGridNoUIScale * pixelH;

							text = "";
							sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
							style = ST_CENTER;
							tooltip = "";
						};

                        // Play now
                        class DMORBAT_BT_MainMenu_PlayNow:DMORBAT_Button
                        {
                            idc = IDC_BT_PLAYNOW;

                            x = 8 * pixelGridNoUIScale * pixelW;
                            y = 47 * pixelGridNoUIScale * pixelH;
                            w = 10 * pixelGridNoUIScale * pixelW;
                            h = 2 * pixelGridNoUIScale * pixelH;

                            text = "";
                            sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                            style = ST_CENTER;
                            colorBackground[] = {1,0.5,0,1};
                            tooltip = "";
                        };
						
                        // Process description
						class DMORBAT_Bckg_MainMenu_ProcessDesc:RscPicture
						{
							idc = -1;
							x = (2 * pixelGridNoUIScale * pixelW);
							y = safezoneH - (14 * pixelGridNoUIScale * pixelH);
							w = (21 * pixelGridNoUIScale * pixelW);
							h = (13 * pixelGridNoUIScale * pixelH);
							
							text = "#(rgb,8,8,3)color(0.2,0.2,0.2,0.5)";
						};

						class DMORBAT_Txt_MainMenu_ProcessDesc:DMORBAT_StaticText
						{
							idc = IDC_MM_PROCESS_DESC;

							x = (2.5 * pixelGridNoUIScale * pixelW);
							y = safezoneH - (13 * pixelGridNoUIScale * pixelH);
							w = (21 * pixelGridNoUIScale * pixelW);	
							h = (11 * pixelGridNoUIScale * pixelH);

							colorText[] = {1,1,1,1};
							colorBackground[] = {0.2,0.2,0.2,0};
							text = "";
							font = GUI_FONT_MONO;
							style = ST_LEFT + ST_MULTI;
						    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 0.8) * 0.5;
                            lineSpacing = 1.25;
							tooltip = "";
						};
					};
				};
			};
		};

        // ---- PREVIEW AREA ----

        // Vehicle Info
        class DMORBAT_Grp_VehicleInfo: RscControlsGroupNoScrollbars {
            idc = IDC_GRP_VEHICLEINFO; 

            x = safezoneX + (safezoneW - (20 * pixelGridNoUIScale * pixelW));
            y = safezoneY + (11 * pixelGridNoUIScale * pixelH);
            w = (safezoneW - (20 * pixelGridNoUIScale * pixelW));
            h = (5 * pixelGridNoUIScale * pixelH);
            class Controls {
        
                class DMORBAT_Bckg_VehicleInfo:RscPicture
                {
                    idc = IDC_BCKG_VEHICLEINFO;
                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 0 * pixelGridNoUIScale * pixelH;
                    w = 20 * pixelGridNoUIScale * pixelW;
                    h = 5 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(0,0,0,0.5)";
                };

                class DMORBAT_Title_VehicleInfo_1:DMORBAT_StaticText
                {
                    idc = IDC_TITLE_VEHICLEINFO_1;

                    x = 0.5 * pixelGridNoUIScale * pixelW;
                    y = 0.2 * pixelGridNoUIScale * pixelH;
                    w = 8 * pixelGridNoUIScale * pixelW;
                    h = 1 * pixelGridNoUIScale * pixelH;

                    colorText[] = {1,1,1,1};
                    colorBackground[] = {0.2,0.2,0.2,0};
                    text = "";
                    font = GUI_FONT_BOLD;
                    style = ST_RIGHT;
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1) * 0.5;
                    tooltip = "";
                };

                class DMORBAT_Txt_VehicleInfo_1:DMORBAT_StaticText
                {
                    idc = IDC_TXT_VEHICLEINFO_1;

                    x = 8.3 * pixelGridNoUIScale * pixelW;
                    y = 0.2 * pixelGridNoUIScale * pixelH;
                    w = 11 * pixelGridNoUIScale * pixelW;
                    h = 1 * pixelGridNoUIScale * pixelH;

                    colorText[] = {1,1,1,1};
                    colorBackground[] = {0.2,0.2,0.2,0};
                    text = "";
                    font = GUI_FONT_THIN;
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1) * 0.5;
                    tooltip = "";
                };

                class DMORBAT_Title_VehicleInfo_2:DMORBAT_StaticText
                {
                    idc = IDC_TITLE_VEHICLEINFO_2;

                    x = 0.5 * pixelGridNoUIScale * pixelW;
                    y = 1.2 * pixelGridNoUIScale * pixelH;
                    w = 8 * pixelGridNoUIScale * pixelW;
                    h = 1 * pixelGridNoUIScale * pixelH;

                    colorText[] = {1,1,1,1};
                    colorBackground[] = {0.2,0.2,0.2,0};
                    text = "";
                    font = GUI_FONT_BOLD;
                    style = ST_RIGHT;
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1) * 0.5;
                    tooltip = "";
                };

                class DMORBAT_Txt_VehicleInfo_2:DMORBAT_StaticText
                {
                    idc = IDC_TXT_VEHICLEINFO_2;

                    x = 8.3 * pixelGridNoUIScale * pixelW;
                    y = 1.2 * pixelGridNoUIScale * pixelH;
                    w = 11 * pixelGridNoUIScale * pixelW;
                    h = 3 * pixelGridNoUIScale * pixelH;

                    colorText[] = {1,1,1,1};
                    colorBackground[] = {0.2,0.2,0.2,0};
                    text = "";
                    font = GUI_FONT_THIN;
                    style = ST_MULTI;
                    lineSpacing = 1;
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1) * 0.5;
                    tooltip = "";
                };
            };
        };

        // Camera controls
        class DMORBAT_Grp_CameraControls: DMORBAT_Controls_Group {
            idc = IDC_GRP_CAM_CONTROLS; 

            x = SafeZoneX + (SafeZoneW - (5.8 * pixelGridNoUIScale * pixelW));
            y = SafeZoneY + (SafeZoneH - (20 * pixelGridNoUIScale * pixelH));
            w = 8 * pixelGridNoUIScale * pixelW;
            h = 5 * pixelGridNoUIScale * pixelH;
        
            class Controls {
                class DMORBAT_Bckg_CameraControlsPositioningTest:RscPicture
                {
                    idc = -1;
                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 0 * pixelGridNoUIScale * pixelH;
                    w = 8 * pixelGridNoUIScale * pixelW;    
                    h = 5 * pixelGridNoUIScale * pixelH;

                    text = "#(rgb,8,8,3)color(1,0,0,0)";
                };

                // BCKG
                class DMORBAT_Bckg_CameraControlsMain:RscPicture
                {
                    idc = -1;
                    x = 0.95 * pixelGridNoUIScale * pixelW;
                    y = 0.9 * pixelGridNoUIScale * pixelH;
                    w = 5.05 * pixelGridNoUIScale * pixelW; 
                    h = 3.15 * pixelGridNoUIScale * pixelH;

                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                // ZOOM OUT
                class DMORBAT_BT_CameraControls_ZoomOut:DMORBAT_InvisibleButton
                {
                    idc = IDC_BT_CAM_CONTROLS_ZOOMOUT;
                    x = 1 * pixelGridNoUIScale * pixelW;
                    y = 1 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;
                };
                class DMORBAT_Bckg_CameraControls_ZoomOut:RscPicture
                {
                    idc = -1;
                    x = 1 * pixelGridNoUIScale * pixelW;
                    y = 1 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    text = "images\dialogs\zoomout.paa";
                };

                // UP
                class DMORBAT_BT_CameraControls_MoveUp:DMORBAT_InvisibleButton
                {
                    idc = IDC_BT_CAM_CONTROLS_UP;
                    x = 2.55 * pixelGridNoUIScale * pixelW;
                    y = 1 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;
                };
                class DMORBAT_Bckg_CameraControls_MoveUp:RscPicture
                {
                    idc = -1;
                    x = 2.55 * pixelGridNoUIScale * pixelW;
                    y = 1 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    text = "images\dialogs\up.paa";             };

                // ZOOM IN
                class DMORBAT_BT_CameraControls_ZoomIn:DMORBAT_InvisibleButton
                {
                    idc = IDC_BT_CAM_CONTROLS_ZOOMIN;
                    x = 4.1 * pixelGridNoUIScale * pixelW;
                    y = 1 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;
                };
                class DMORBAT_Bckg_CameraControls_ZoomIn:RscPicture
                {
                    idc = -1;
                    x = 4.1 * pixelGridNoUIScale * pixelW;
                    y = 1 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    text = "images\dialogs\zoomin.paa";
                };

                // LEFT
                class DMORBAT_BT_CameraControls_MoveLeft:DMORBAT_InvisibleButton
                {
                    idc = IDC_BT_CAM_CONTROLS_LEFT;
                    x = 1 * pixelGridNoUIScale * pixelW;
                    y = 2.55 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;
                };
                class DMORBAT_Bckg_CameraControls_MoveLeft:RscPicture
                {
                    idc = -1;
                    x = 1 * pixelGridNoUIScale * pixelW;
                    y = 2.55 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    text = "images\dialogs\left.paa";
                };

                // DOWN
                class DMORBAT_BT_CameraControls_MoveDown:DMORBAT_InvisibleButton
                {
                    idc = IDC_BT_CAM_CONTROLS_DOWN;
                    x = 2.55 * pixelGridNoUIScale * pixelW;
                    y = 2.55 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;
                };
                class DMORBAT_Bckg_CameraControls_MoveDown:RscPicture
                {
                    idc = -1;
                    x = 2.55 * pixelGridNoUIScale * pixelW;
                    y = 2.55 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    text = "images\dialogs\down.paa";
                };

                // RIGHT
                class DMORBAT_BT_CameraControls_MoveRight:DMORBAT_InvisibleButton
                {
                    idc = IDC_BT_CAM_CONTROLS_RIGHT;
                    x = 4.1 * pixelGridNoUIScale * pixelW;
                    y = 2.55 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;
                };
                class DMORBAT_Bckg_CameraControls_MoveRight:RscPicture
                {
                    idc = -1;
                    x = 4.1 * pixelGridNoUIScale * pixelW;
                    y = 2.55 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    text = "images\dialogs\right.paa";
                };
            };
        };

        // Camera type selection
        class DMORBAT_Grp_CameraType: DMORBAT_Controls_Group {
            idc = IDC_GRP_CAM_TYPE; 

            x = SafeZoneX + (SafeZoneW - (8.7 * pixelGridNoUIScale * pixelW));
            y = SafeZoneY + (SafeZoneH - (15 * pixelGridNoUIScale * pixelH));
            w = 4 * pixelGridNoUIScale * pixelW;
            h = 10 * pixelGridNoUIScale * pixelH;
        
            class Controls {
                class DMORBAT_Grp_CameraTypePositioningTest:RscPicture
                {
                    idc = -1;
                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 0 * pixelGridNoUIScale * pixelH;
                    w = 3 * pixelGridNoUIScale * pixelW;    
                    h = 10 * pixelGridNoUIScale * pixelH;

                    text = "#(rgb,8,8,3)color(1,0,0,0)";
                };

                // BCKG
                class DMORBAT_Bckg_CameraTypeMain:RscPicture
                {
                    idc = -1;
                    x = 0.95 * pixelGridNoUIScale * pixelW;
                    y = 0.9 * pixelGridNoUIScale * pixelH;
                    w = 1.8 * pixelGridNoUIScale * pixelW;    
                    h = 4.8 * pixelGridNoUIScale * pixelH;

                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                // TOP
                class DMORBAT_BT_CameraType_Top:DMORBAT_InvisibleButton
                {
                    idc = IDC_BT_CAM_TYPE_TOP;
                    x = 1 * pixelGridNoUIScale * pixelW;
                    y = 1 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;
                };
                class DMORBAT_Bckg_CameraType_Top:RscPicture
                {
                    idc = -1;
                    x = 1 * pixelGridNoUIScale * pixelW;
                    y = 1 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    text = "images\dialogs\camtop.paa";
                };

                // HIGH
                class DMORBAT_BT_CameraType_High:DMORBAT_InvisibleButton
                {
                    idc = IDC_BT_CAM_TYPE_HIGH;
                    x = 1 * pixelGridNoUIScale * pixelW;
                    y = 2.55 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;
                };
                class DMORBAT_Bckg_CameraType_High:RscPicture
                {
                    idc = -1;
                    x = 1 * pixelGridNoUIScale * pixelW;
                    y = 2.55 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    text = "images\dialogs\camangle.paa";             
                };

                // CIRCLING
                class DMORBAT_BT_CameraType_Circling:DMORBAT_InvisibleButton
                {
                    idc = IDC_BT_CAM_TYPE_CIRCLING;
                    x = 1 * pixelGridNoUIScale * pixelW;
                    y = 4.1 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;
                };
                class DMORBAT_Bckg_CameraType_Circling:RscPicture
                {
                    idc = -1;
                    x = 1 * pixelGridNoUIScale * pixelW;
                    y = 4.1 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    text = "images\dialogs\camcircle.paa";
                };
            };
        };

        // Composition Edit controls
        class DMORBAT_Grp_CompEditControls: DMORBAT_Controls_Group {
            idc = IDC_GRP_EDIT_CONTROLS;    

            x = SafeZoneX + (SafeZoneW - (12 * pixelGridNoUIScale * pixelW));
            y = SafeZoneY + (SafeZoneH - (10 * pixelGridNoUIScale * pixelH));
            w = 8 * pixelGridNoUIScale * pixelW;
            h = 7 * pixelGridNoUIScale * pixelH;
        
            class Controls {
                class DMORBAT_Grp_CompEditControlsPositioningTest:RscPicture
                {
                    idc = -1;
                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 0 * pixelGridNoUIScale * pixelH;
                    w = 8 * pixelGridNoUIScale * pixelW;    
                    h = 7 * pixelGridNoUIScale * pixelH;

                    text = "#(rgb,8,8,3)color(1,0,0,0)";
                };

                // BCKG
                class DMORBAT_Bckg_CompEditControlsMain:RscPicture
                {
                    idc = -1;
                    x = 0.95 * pixelGridNoUIScale * pixelW;
                    y = 0.9 * pixelGridNoUIScale * pixelH;
                    w = 5.05 * pixelGridNoUIScale * pixelW; 
                    h = 3.15 * pixelGridNoUIScale * pixelH;

                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                // ROTATE LEFT
                class DMORBAT_BT_CompEditControls_RotateLeft:DMORBAT_InvisibleButton
                {
                    idc = IDC_BT_COMPEDIT_CONTROLS_ROTLEFT;
                    x = 1 * pixelGridNoUIScale * pixelW;
                    y = 1 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;
                };
                class DMORBAT_Bckg_CompEditControls_RotateLeft:RscPicture
                {
                    idc = -1;
                    x = 1 * pixelGridNoUIScale * pixelW;
                    y = 1 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    text = "images\dialogs\rotateleft.paa";
                };

                // UP
                class DMORBAT_BT_CompEditControls_MoveUp:DMORBAT_InvisibleButton
                {
                    idc = IDC_BT_COMPEDIT_CONTROLS_UP;
                    x = 2.55 * pixelGridNoUIScale * pixelW;
                    y = 1 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;
                };
                class DMORBAT_Bckg_CompEditControls_MoveUp:RscPicture
                {
                    idc = -1;
                    x = 2.55 * pixelGridNoUIScale * pixelW;
                    y = 1 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    text = "images\dialogs\moveup.paa";             };

                // ROTATE RIGHT
                class DMORBAT_BT_CompEditControls_RotateRight:DMORBAT_InvisibleButton
                {
                    idc = IDC_BT_COMPEDIT_CONTROLS_ROTRIGHT;
                    x = 4.1 * pixelGridNoUIScale * pixelW;
                    y = 1 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;
                };
                class DMORBAT_Bckg_CompEditControls_RotateRight:RscPicture
                {
                    idc = -1;
                    x = 4.1 * pixelGridNoUIScale * pixelW;
                    y = 1 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    text = "images\dialogs\rotateright.paa";
                };

                // LEFT
                class DMORBAT_BT_CompEditControls_MoveLeft:DMORBAT_InvisibleButton
                {
                    idc = IDC_BT_COMPEDIT_CONTROLS_LEFT;
                    x = 1 * pixelGridNoUIScale * pixelW;
                    y = 2.55 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;
                };
                class DMORBAT_Bckg_CompEditControls_MoveLeft:RscPicture
                {
                    idc = -1;
                    x = 1 * pixelGridNoUIScale * pixelW;
                    y = 2.55 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    text = "images\dialogs\moveleft.paa";
                };

                // DOWN
                class DMORBAT_BT_CompEditControls_MoveDown:DMORBAT_InvisibleButton
                {
                    idc = IDC_BT_COMPEDIT_CONTROLS_DOWN;
                    x = 2.55 * pixelGridNoUIScale * pixelW;
                    y = 2.55 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;
                };
                class DMORBAT_Bckg_CompEditControls_MoveDown:RscPicture
                {
                    idc = -1;
                    x = 2.55 * pixelGridNoUIScale * pixelW;
                    y = 2.55 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    text = "images\dialogs\movedown.paa";
                };

                // RIGHT
                class DMORBAT_BT_CompEditControls_MoveRight:DMORBAT_InvisibleButton
                {
                    idc = IDC_BT_COMPEDIT_CONTROLS_RIGHT;
                    x = 4.1 * pixelGridNoUIScale * pixelW;
                    y = 2.55 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;
                };
                class DMORBAT_Bckg_CompEditControls_MoveRight:RscPicture
                {
                    idc = -1;
                    x = 4.1 * pixelGridNoUIScale * pixelW;
                    y = 2.55 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    text = "images\dialogs\moveright.paa";
                };

                class DMORBAT_BT_CompEditControls_Close:DMORBAT_Button
                {
                    idc = IDC_BT_COMPEDIT_CONTROLS_CLOSE;

                    x = 1 * pixelGridNoUIScale * pixelW;
                    y = 4.5 * pixelGridNoUIScale * pixelH;
                    w = 6 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                };
            };
        };

        // Map controls
        class DMORBAT_Grp_AOMapControls: DMORBAT_Controls_Group {
            idc = IDC_GRP_AO_MAP_CONTROLS;  

            x = SafeZoneX + (SafeZoneW - (9.5 * pixelGridNoUIScale * pixelW));
            y = safezoneY + (11 * pixelGridNoUIScale * pixelH);
            w = (9.5 * pixelGridNoUIScale * pixelW);
            h = (5.5 * pixelGridNoUIScale * pixelH);
        
            class Controls {
                // class DMORBAT_AOselectionPositioningTest:RscPicture
                // {
                //  idc = -1;
                //  x = 0 * pixelGridNoUIScale * pixelW;
                //  y = 0 * pixelGridNoUIScale * pixelH;
                //  w = (10 * pixelGridNoUIScale * pixelW); 
                //  h = (4 * pixelGridNoUIScale * pixelH);

                //  text = "#(rgb,8,8,3)color(1,0,0,0.5)";
                // };

                class DMORBAT_BT_AOMapPreviewCoords:DMORBAT_NoBorderButton
                {
                    idc = IDC_BT_AO_SEL_PREVIEW_COORDS;
                    x = 1 * pixelGridNoUIScale * pixelW;
                    y = 0.3 * pixelGridNoUIScale * pixelH;
                    w = 8 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;

                    text = "";
                    sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                    tooltip = "";
                };

                class DMORBAT_BT_AOMapSwitchMap:DMORBAT_NoBorderButton
                {
                    idc = IDC_BT_AO_SEL_SWITCHMAP;
                    x = 1 * pixelGridNoUIScale * pixelW;
                    y = 2.8 * pixelGridNoUIScale * pixelH;
                    w = 8 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;

                    text = "";
                    sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                    tooltip = "";
                };
            };
        };
        
        // Map crosshair
        class DMORBAT_Img_MapCrosshair:RscPicture
        {
            idc = IDC_IMG_MAPCROSSHAIR;

            x = safezoneX + (20 * pixelGridNoUIScale * pixelW);
            y = safezoneY + (11 * pixelGridNoUIScale * pixelH);
            w = (1 * pixelGridNoUIScale * pixelW);
            h = (1 * pixelGridNoUIScale * pixelH);
                    
            text = "#(rgb,8,8,3)color(1,0,0,0.5)";
        };

        // ---- MENUS - LEFT & BOTTOM AREA ----

		// Left - Faction groups and units
		class DMORBAT_Grp_FactionGroupsSelection: DMORBAT_Controls_Group {
			idc = IDC_GRP_FACTION_GROUPS;		
			x = SafeZoneX + (0 * pixelGridNoUIScale * pixelW);
			y = SafeZoneY + (0 * pixelGridNoUIScale * pixelH);
			w = (20 * pixelGridNoUIScale * pixelW);
			h = safezoneH - (10 * pixelGridNoUIScale * pixelH);
		
			class Controls {

				// Faction combo title
				class DMORBAT_FactionSelectionBckgHStrip1:RscPicture
				{
					idc = IDC_BCKG_FACTION_TITLE_HSTRIP1;

					x = 0 * pixelGridNoUIScale * pixelW;
					y = 5.5 * pixelGridNoUIScale * pixelH;
					w = 2 * pixelGridNoUIScale * pixelW;
					h = 2 * pixelGridNoUIScale * pixelH;
					
					text = "#(rgb,8,8,3)color(1,0.5,0,1)";
				};

				class DMORBAT_FactionSelectionBckgHStrip2:RscPicture
				{
					idc = IDC_BCKG_FACTION_TITLE_HSTRIP2;

					x = 2 * pixelGridNoUIScale * pixelW;
					y = 5.5 * pixelGridNoUIScale * pixelH;
					w = 16 * pixelGridNoUIScale * pixelW;
					h = 2 * pixelGridNoUIScale * pixelH;
					
					text = "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
				};

				class DMORBAT_FactionSelectionBckgHStrip3:RscPicture
				{
					idc = IDC_BCKG_FACTION_TITLE_HSTRIP3;

					x = 18 * pixelGridNoUIScale * pixelW;
					y = 5.5 * pixelGridNoUIScale * pixelH;
					w = 0.5 * pixelGridNoUIScale * pixelW;
					h = 2 * pixelGridNoUIScale * pixelH;
					
					text = "#(rgb,8,8,3)color(1,0.5,0,1)";
				};

				class DMORBAT_FactionSelectionTitle:DMORBAT_StaticText
				{
					idc = IDC_FACTION_TITLE;

					x = 2 * pixelGridNoUIScale * pixelW;
					y = 5.6 * pixelGridNoUIScale * pixelH;
					w = 16 * pixelGridNoUIScale * pixelW;
					h = 2 * pixelGridNoUIScale * pixelH;

					text = "";
					font = GUI_FONT_BOLD;
					sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.75) * 0.5;
					colorText[] = {1,1,1,1};
					colorBackground[] = {1,0.5,0,0};
					tooltip = "";
				};

				class DMORBAT_FactionSelection:DMORBAT_Combo
				{
					idc = IDC_COMBO_FACTIONS;

					x = 2.5 * pixelGridNoUIScale * pixelW;
					y = 8 * pixelGridNoUIScale * pixelH;
					w = 16 * pixelGridNoUIScale * pixelW;
					h = 2 * pixelGridNoUIScale * pixelH;

					sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.5) * 0.5;	
					rowHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 1.5) * 0.5;
					wholeHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 25) * 0.5;
					tooltip = "";
				};

				// Faction groups title
				class DMORBAT_FactionGroupsSelectionBckgHStrip1:RscPicture
				{
					idc = -1;

					x = 0 * pixelGridNoUIScale * pixelW;
					y = 11 * pixelGridNoUIScale * pixelH;
					w = 2 * pixelGridNoUIScale * pixelW;
					h = 2 * pixelGridNoUIScale * pixelH;
					
					text = "#(rgb,8,8,3)color(1,0.5,0,1)";
				};

				class DMORBAT_FactionGroupsSelectionBckgHStrip2:RscPicture
				{
					idc = -1;

					x = 2 * pixelGridNoUIScale * pixelW;
					y = 11 * pixelGridNoUIScale * pixelH;
					w = 16 * pixelGridNoUIScale * pixelW;
					h = 2 * pixelGridNoUIScale * pixelH;
					
					text = "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
				};

				class DMORBAT_FactionGroupsSelectionBckgHStrip3:RscPicture
				{
					idc = -1;

					x = 18 * pixelGridNoUIScale * pixelW;
					y = 11 * pixelGridNoUIScale * pixelH;
					w = 0.5 * pixelGridNoUIScale * pixelW;
					h = 2 * pixelGridNoUIScale * pixelH;
					
					text = "#(rgb,8,8,3)color(1,0.5,0,1)";
				};

				class DMORBAT_FactionGroupListTitle:DMORBAT_StaticText
				{
					idc = IDC_TITLE_FACTION_GROUPS;

					x = 2 * pixelGridNoUIScale * pixelW;
					y = 11.1 * pixelGridNoUIScale * pixelH;
					w = 16 * pixelGridNoUIScale * pixelW;
					h = 2 * pixelGridNoUIScale * pixelH;

                    text = "";
                    font = GUI_FONT_BOLD;
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.75) * 0.5;
                    colorText[] = {1,1,1,1};
                    colorBackground[] = {1,0.5,0,0};
                    tooltip = "";
				};

				class DMORBAT_FactionGroupList:DMORBAT_Tree
				{
					idc = IDC_TREE_FACTION_GROUPS;

					x = 2.5 * pixelGridNoUIScale * pixelW;
					y = 13.5 * pixelGridNoUIScale * pixelH;
					w = 16 * pixelGridNoUIScale * pixelW;
					h = 10 * pixelGridNoUIScale * pixelH;

					tooltip = "";
					sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
					multiselectEnabled = 0; // Allow selecting multiple items while holding Ctrl or Shift
					expandOnDoubleclick = 1; // Expand/collapse item upon double-click
					maxHistoryDelay = 1; // Time since last keyboard type search to reset it
				};

				class DMORBAT_AddGroupButton:DMORBAT_Button
				{
					idc = IDC_BT_ADD_GROUP;

					x = 3.8 * pixelGridNoUIScale * pixelW;
					y = 24.5 * pixelGridNoUIScale * pixelH;
					w = 14 * pixelGridNoUIScale * pixelW;
					h = 2 * pixelGridNoUIScale * pixelH;

					text = "";
					sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
					tooltip = "";
				};

				// Faction units title
				class DMORBAT_FactionUnitsSelectionBckgHStrip1:RscPicture
				{
					idc = -1;

					x = 0 * pixelGridNoUIScale * pixelW;
					y = 27.5 * pixelGridNoUIScale * pixelH;
					w = 2 * pixelGridNoUIScale * pixelW;
					h = 2 * pixelGridNoUIScale * pixelH;
					
					text = "#(rgb,8,8,3)color(1,0.5,0,1)";
				};

				class DMORBAT_FactionUnitsSelectionBckgHStrip2:RscPicture
				{
					idc = -1;

					x = 2 * pixelGridNoUIScale * pixelW;
					y = 27.5 * pixelGridNoUIScale * pixelH;
					w = 16 * pixelGridNoUIScale * pixelW;
					h = 2 * pixelGridNoUIScale * pixelH;
					
					text = "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
				};

				class DMORBAT_FactionUnitsSelectionBckgHStrip3:RscPicture
				{
					idc = -1;

					x = 18 * pixelGridNoUIScale * pixelW;
					y = 27.5 * pixelGridNoUIScale * pixelH;
					w = 0.5 * pixelGridNoUIScale * pixelW;
					h = 2 * pixelGridNoUIScale * pixelH;
					
					text = "#(rgb,8,8,3)color(1,0.5,0,1)";
				};

				class DMORBAT_FactionUnitsListTitle:DMORBAT_StaticText
				{
					idc = IDC_TITLE_FACTION_UNITS;

					x = 2 * pixelGridNoUIScale * pixelW;
					y = 27.6 * pixelGridNoUIScale * pixelH;
					w = 16 * pixelGridNoUIScale * pixelW;
					h = 2 * pixelGridNoUIScale * pixelH;

                    text = "";
                    font = GUI_FONT_BOLD;
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.75) * 0.5;
                    colorText[] = {1,1,1,1};
                    colorBackground[] = {1,0.5,0,0};
                    tooltip = "";
				};

				class DMORBAT_FactionUnitsList:DMORBAT_Tree
				{
					idc = IDC_TREE_FACTION_UNITS;

					x = 2.5 * pixelGridNoUIScale * pixelW;
					y = 30.1 * pixelGridNoUIScale * pixelH;
					w = 16 * pixelGridNoUIScale * pixelW;
					h = 10 * pixelGridNoUIScale * pixelH;

					tooltip = "";
					sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
					multiselectEnabled = 0; // Allow selecting multiple items while holding Ctrl or Shift
					expandOnDoubleclick = 1; // Expand/collapse item upon double-click
					maxHistoryDelay = 1; // Time since last keyboard type search to reset it
				};

				class DMORBAT_AddUnitButton:DMORBAT_Button
				{
					idc = IDC_BT_ADD_UNIT;

					x = 3.8 * pixelGridNoUIScale * pixelW;
					y = 41.1 * pixelGridNoUIScale * pixelH;
					w = 14 * pixelGridNoUIScale * pixelW;
					h = 2 * pixelGridNoUIScale * pixelH;

					text = "";
					sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
					tooltip = "";
				};
			};
		};

		// Left - AO selection
		class DMORBAT_Grp_AOselection: DMORBAT_Controls_Group {
			idc = IDC_GRP_AO_SELECTION;		
			x = SafeZoneX + (0 * pixelGridNoUIScale * pixelW);
			y = SafeZoneY + (0 * pixelGridNoUIScale * pixelH);
			w = (20 * pixelGridNoUIScale * pixelW);
			h = safezoneH - (10 * pixelGridNoUIScale * pixelH);
		
			class Controls {

                // Categories
                class DMORBAT_AOselection_Cat_BckgHStrip1:RscPicture
                {
                    idc = -1;

                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 5.5 * pixelGridNoUIScale * pixelH;
                    w = 2 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                class DMORBAT_AOselection_Cat_BckgHStrip2:RscPicture
                {
                    idc = -1;

                    x = 2 * pixelGridNoUIScale * pixelW;
                    y = 5.5 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
                };

                class DMORBAT_AOselection_Cat_BckgHStrip3:RscPicture
                {
                    idc = -1;

                    x = 18 * pixelGridNoUIScale * pixelW;
                    y = 5.5 * pixelGridNoUIScale * pixelH;
                    w = 0.5 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                class DMORBAT_Title_AOselection_Cat_Title:DMORBAT_StaticText
                {
                    idc = IDC_TITLE_AO_SELECTION_CAT;

                    x = 2 * pixelGridNoUIScale * pixelW;
                    y = 5.6 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;

                    text = "";
                    font = GUI_FONT_BOLD;
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.75) * 0.5;
                    colorText[] = {1,1,1,1};
                    colorBackground[] = {1,0.5,0,0};
                    tooltip = "";
                };

                class DMORBAT_Combo_AOselection_Cat_:DMORBAT_Combo
                {
                    idc = IDC_COMBO_AO_SELECTION_CAT;

                    x = 2.5 * pixelGridNoUIScale * pixelW;
                    y = 8 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;

                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.5) * 0.5; 
                    rowHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 1.5) * 0.5;
                    wholeHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 25) * 0.5;
                    tooltip = "";
                };

                // Locations
                class DMORBAT_AOselection_Loc_BckgHStrip1:RscPicture
                {
                    idc = -1;

                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 11 * pixelGridNoUIScale * pixelH;
                    w = 2 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                class DMORBAT_AOselection_Loc_BckgHStrip2:RscPicture
                {
                    idc = -1;

                    x = 2 * pixelGridNoUIScale * pixelW;
                    y = 11 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
                };

                class DMORBAT_AOselection_Loc_BckgHStrip3:RscPicture
                {
                    idc = -1;

                    x = 18 * pixelGridNoUIScale * pixelW;
                    y = 11 * pixelGridNoUIScale * pixelH;
                    w = 0.5 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                class DMORBAT_Title_AOselection_Loc:DMORBAT_StaticText
                {
                    idc = IDC_TITLE_AO_SELECTION_LOC;

                    x = 2 * pixelGridNoUIScale * pixelW;
                    y = 11.1 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;

                    text = "";
                    font = GUI_FONT_BOLD;
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.75) * 0.5;
                    colorText[] = {1,1,1,1};
                    colorBackground[] = {1,0.5,0,0};
                    tooltip = "";
                };

                class DMORBAT_Combo_AOselection_Loc:DMORBAT_Combo
                {
                    idc = IDC_COMBO_AO_SELECTION_LOC;

                    x = 2.5 * pixelGridNoUIScale * pixelW;
                    y = 13.5 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;

                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.5) * 0.5; 
                    rowHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 1.5) * 0.5;
                    wholeHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 25) * 0.5;
                    tooltip = "";
                };

				class DMORBAT_BT_AOselection_Loc_Set:DMORBAT_NoBorderButton
				{
					idc = IDC_BT_AO_SEL_SET;
                    x = 3.8 * pixelGridNoUIScale * pixelW;
					y = 16 * pixelGridNoUIScale * pixelH;
					w = 8 * pixelGridNoUIScale * pixelW;
					h = 1.5 * pixelGridNoUIScale * pixelH;

					text = "";
					sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
					tooltip = "";
				};

				class DMORBAT_BT_AOselection_Loc_Remove:DMORBAT_NoBorderButton
				{
					idc = IDC_BT_AO_SEL_REMOVE;
                    x = 3.8 * pixelGridNoUIScale * pixelW;
					y = 18 * pixelGridNoUIScale * pixelH;
                    w = 8 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

					text = "";
					sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
					tooltip = "";
				};

				class DMORBAT_BT_AOselection_Loc_Add:DMORBAT_NoBorderButton
				{
					idc = IDC_BT_AO_SEL_ADD;
                    x = 3.8 * pixelGridNoUIScale * pixelW;
					y = 20 * pixelGridNoUIScale * pixelH;
                    w = 8 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

					text = "";
					sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
					tooltip = "";
				};

				// Rotate
				class DMORBAT_BT_AOselection_Loc_RotLeft:DMORBAT_NoBorderButton
				{
					idc = IDC_BT_AO_SEL_ROTATE_LEFT;
					x = 12.5 * pixelGridNoUIScale * pixelW;
					y = 16 * pixelGridNoUIScale * pixelH;
					w = 6 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

					text = "";
					sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
					tooltip = "";
				};

				class DMORBAT_BT_AOselection_Loc_RotRight:DMORBAT_NoBorderButton
				{
					idc = IDC_BT_AO_SEL_ROTATE_RIGHT;
                    x = 12.5 * pixelGridNoUIScale * pixelW;
					y = 18 * pixelGridNoUIScale * pixelH;
					w = 6 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

					text = "";
					sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
					tooltip = "";
				};

				// Compositions
                class DMORBAT_AOselection_Comp_BckgHStrip1:RscPicture
                {
                    idc = -1;

                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 22.5 * pixelGridNoUIScale * pixelH;
                    w = 2 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                class DMORBAT_AOselection_Comp_BckgHStrip2:RscPicture
                {
                    idc = -1;

                    x = 2 * pixelGridNoUIScale * pixelW;
                    y = 22.5 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
                };

                class DMORBAT_AOselection_Comp_BckgHStrip3:RscPicture
                {
                    idc = -1;

                    x = 18 * pixelGridNoUIScale * pixelW;
                    y = 22.5 * pixelGridNoUIScale * pixelH;
                    w = 0.5 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

				class DMORBAT_Title_AOselection_Comp:DMORBAT_StaticText
				{
					idc = IDC_TITLE_AO_SELECTION_COMP;

					x = 2 * pixelGridNoUIScale * pixelW;
                    y = 22.6 * pixelGridNoUIScale * pixelH;
					w = 16 * pixelGridNoUIScale * pixelW;
					h = 2 * pixelGridNoUIScale * pixelH;

                    text = "";
                    font = GUI_FONT_BOLD;
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.75) * 0.5;
                    colorText[] = {1,1,1,1};
                    colorBackground[] = {1,0.5,0,0};
                    tooltip = "";
				};

				class DMORBAT_Tree_AOselection_Comp:DMORBAT_Tree
				{
					idc = IDC_TREE_AO_SELECTION_COMP;

					x = 2.5 * pixelGridNoUIScale * pixelW;
					y = 25 * pixelGridNoUIScale * pixelH;
					w = 16 * pixelGridNoUIScale * pixelW;
					h = 10 * pixelGridNoUIScale * pixelH;

					tooltip = "";
					sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
					multiselectEnabled = 0; // Allow selecting multiple items while holding Ctrl or Shift
					expandOnDoubleclick = 1; // Expand/collapse item upon double-click
					maxHistoryDelay = 1; // Time since last keyboard type search to reset it
				};

				class DMORBAT_BT_AOselection_Comp_Add:DMORBAT_NoBorderButton
				{
					idc = IDC_BT_AO_SEL_COMP_ADD;
					x = 3.8 * pixelGridNoUIScale * pixelW;
					y = 35.5 * pixelGridNoUIScale * pixelH;
					w = 8 * pixelGridNoUIScale * pixelW;
					h = 1.5 * pixelGridNoUIScale * pixelH;

					text = "";
					sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
					tooltip = "";
				};
			};
		};

        // Left - Support
        class DMORBAT_Grp_Support: DMORBAT_Controls_Group {
            idc = IDC_GRP_SUPPORT;     
            x = SafeZoneX + (0 * pixelGridNoUIScale * pixelW);
            y = SafeZoneY + (0 * pixelGridNoUIScale * pixelH);
            w = (20 * pixelGridNoUIScale * pixelW);
            h = safezoneH - (10 * pixelGridNoUIScale * pixelH);
        
            class Controls {

                // Faction combo title
                class DMORBAT_Title_Support_Factions_BckgHStrip1:RscPicture
                {
                    idc = -1;

                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 5.5 * pixelGridNoUIScale * pixelH;
                    w = 2 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                class DMORBAT_Title_Support_Factions_BckgHStrip2:RscPicture
                {
                    idc = -1;

                    x = 2 * pixelGridNoUIScale * pixelW;
                    y = 5.5 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
                };

                class DMORBAT_Title_Support_Factions_BckgHStrip3:RscPicture
                {
                    idc = -1;

                    x = 18 * pixelGridNoUIScale * pixelW;
                    y = 5.5 * pixelGridNoUIScale * pixelH;
                    w = 0.5 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                class DMORBAT_Title_Support_Factions:DMORBAT_StaticText
                {
                    idc = IDC_TITLE_SUPPORT_FACTIONS;

                    x = 2 * pixelGridNoUIScale * pixelW;
                    y = 5.6 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;

                    text = "";
                    font = GUI_FONT_BOLD;
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.75) * 0.5;
                    colorText[] = {1,1,1,1};
                    colorBackground[] = {1,0.5,0,0};
                    tooltip = "";
                };

                class DMORBAT_Combo_Support_Factions:DMORBAT_Combo
                {
                    idc = IDC_COMBO_SUPPORT_FACTIONS;

                    x = 2.5 * pixelGridNoUIScale * pixelW;
                    y = 8 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;

                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.5) * 0.5; 
                    rowHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 1.5) * 0.5;
                    wholeHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 25) * 0.5;
                    tooltip = "";
                };

                // Support types
                class DMORBAT_Title_Support_BckgHStrip1:RscPicture
                {
                    idc = -1;

                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 11 * pixelGridNoUIScale * pixelH;
                    w = 2 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                class DMORBAT_Title_Support_BckgHStrip2:RscPicture
                {
                    idc = -1;

                    x = 2 * pixelGridNoUIScale * pixelW;
                    y = 11 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
                };

                class DMORBAT_Title_Support_BckgHStrip3:RscPicture
                {
                    idc = -1;

                    x = 18 * pixelGridNoUIScale * pixelW;
                    y = 11 * pixelGridNoUIScale * pixelH;
                    w = 0.5 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                class DMORBAT_Title_Support_Types:DMORBAT_StaticText
                {
                    idc = IDC_TITLE_SUPPORT_TYPES;

                    x = 2 * pixelGridNoUIScale * pixelW;
                    y = 11.1 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;

                    text = "";
                    font = GUI_FONT_BOLD;
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.75) * 0.5;
                    colorText[] = {1,1,1,1};
                    colorBackground[] = {1,0.5,0,0};
                    tooltip = "";
                };

                class DMORBAT_Combo_Support_Types:DMORBAT_Combo
                {
                    idc = IDC_COMBO_SUPPORT_TYPES;

                    x = 2.5 * pixelGridNoUIScale * pixelW;
                    y = 13.5 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;

                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.5) * 0.5; 
                    rowHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 1.5) * 0.5;
                    wholeHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 25) * 0.5;
                    tooltip = "";
                };

                // Support options
                class DMORBAT_Title_Support_Options_BckgHStrip1:RscPicture
                {
                    idc = -1;

                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 16.5 * pixelGridNoUIScale * pixelH;
                    w = 2 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                class DMORBAT_Title_Support_Options_BckgHStrip2:RscPicture
                {
                    idc = -1;

                    x = 2 * pixelGridNoUIScale * pixelW;
                    y = 16.5 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
                };

                class DMORBAT_Title_Support_Options_BckgHStrip3:RscPicture
                {
                    idc = -1;

                    x = 18 * pixelGridNoUIScale * pixelW;
                    y = 16.5 * pixelGridNoUIScale * pixelH;
                    w = 0.5 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                class DMORBAT_Title_Support_Options:DMORBAT_StaticText
                {
                    idc = IDC_TITLE_SUPPORT_OPTIONS;

                    x = 2 * pixelGridNoUIScale * pixelW;
                    y = 16.6 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;

                    text = "";
                    font = GUI_FONT_BOLD;
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.75) * 0.5;
                    colorText[] = {1,1,1,1};
                    colorBackground[] = {1,0.5,0,0};
                    tooltip = "";
                };
                
                class DMORBAT_Bckg_EnvSettings_Time:RscPicture
                {
                    idc = IDC_BCKG_SUPPORT_LIMIT;

                    x = 2.5 * pixelGridNoUIScale * pixelW;
                    y = 19 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 4.5 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(0.4,0.4,0.4,1)";
                };

                class DMORBAT_Title_Support_Limit:DMORBAT_StaticText
                {
                    idc = IDC_TITLE_SUPPORT_LIMIT;

                    x = 3 * pixelGridNoUIScale * pixelW;
                    y = 19.5 * pixelGridNoUIScale * pixelH;
                    w = 12 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    colorText[] = {1,1,1,1};
                    colorBackground[] = {0.2,0.2,0.2,0};
                    text = "";
                    font = GUI_FONT_BOLD;
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
                    tooltip = "";
                };

                class DMORBAT_Edit_Support_Limit:RscEdit
                {
                    idc = IDC_EDIT_SUPPORT_LIMIT;

                    x = 5 * pixelGridNoUIScale * pixelW;
                    y = 21.3 * pixelGridNoUIScale * pixelH;
                    w = 2 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    colorText[] = {0,0,0,1};
                    shadow = 0;
                    colorBackground[] = {0.7,0.7,0.7,0.5};
                    text = "";
                    font = GUI_FONT_MONO;
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1) * 0.5;
                    tooltip = "";
                    maxChars = 2;
                };

                class DMORBAT_BT_Support_Limit:DMORBAT_NoBorderButton
                {
                    idc = IDC_BT_SUPPORT_LIMIT;

                    x = 7.6 * pixelGridNoUIScale * pixelW;
                    y = 21.3 * pixelGridNoUIScale * pixelH;
                    w = 2.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    text = "";
                    sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                    tooltip = "";
                };

                class DMORBAT_Chk_Support_Limit:DMORBAT_Checkbox
                {
                    idc = IDC_CHK_SUPPORT_LIMIT;

                    x = 11 * pixelGridNoUIScale * pixelW;
                    y = 21.3 * pixelGridNoUIScale * pixelH;
                    w = 1.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    tooltip = "";
                };

                class DMORBAT_Txt_Support_Limit:DMORBAT_StaticText
                {
                    idc = IDC_TXT_SUPPORT_LIMIT;

                    x = 12.5 * pixelGridNoUIScale * pixelW;
                    y = 21.4 * pixelGridNoUIScale * pixelH;
                    w = 6 * pixelGridNoUIScale * pixelW;
                    h = 1 * pixelGridNoUIScale * pixelH;

                    colorText[] = {1,1,1,1};
                    colorBackground[] = {0.2,0.2,0.2,0};
                    text = "";
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
                    tooltip = "";
                };

                // Support units
                class DMORBAT_Title_Support_Units_BckgHStrip1:RscPicture
                {
                    idc = -1;

                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 24 * pixelGridNoUIScale * pixelH;
                    w = 2 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                class DMORBAT_Title_Support_Units_BckgHStrip2:RscPicture
                {
                    idc = -1;

                    x = 2 * pixelGridNoUIScale * pixelW;
                    y = 24 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
                };

                class DMORBAT_Title_Support_Units_BckgHStrip3:RscPicture
                {
                    idc = -1;

                    x = 18 * pixelGridNoUIScale * pixelW;
                    y = 24 * pixelGridNoUIScale * pixelH;
                    w = 0.5 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                class DMORBAT_Title_Support_Units:DMORBAT_StaticText
                {
                    idc = IDC_TITLE_SUPPORT_UNITS;

                    x = 2 * pixelGridNoUIScale * pixelW;
                    y = 24.1 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;

                    text = "";
                    font = GUI_FONT_BOLD;
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.75) * 0.5;
                    colorText[] = {1,1,1,1};
                    colorBackground[] = {1,0.5,0,0};
                    tooltip = "";
                };

                class DMORBAT_Tree_Support_Units:DMORBAT_Tree
                {
                    idc = IDC_TREE_SUPPORT_UNITS;

                    x = 2.5 * pixelGridNoUIScale * pixelW;
                    y = 26.5 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 10 * pixelGridNoUIScale * pixelH;

                    tooltip = "";
                    sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                    multiselectEnabled = 0; // Allow selecting multiple items while holding Ctrl or Shift
                    expandOnDoubleclick = 1; // Expand/collapse item upon double-click
                    maxHistoryDelay = 1; // Time since last keyboard type search to reset it
                };

                class DMORBAT_BT_Support_Units_Add:DMORBAT_Button
                {
                    idc = IDC_BT_SUPPORT_UNITS_ADD;
                    x = 3.8 * pixelGridNoUIScale * pixelW;
                    y = 37.5 * pixelGridNoUIScale * pixelH;
                    w = 14 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;

                    text = "";
                    sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                    tooltip = "";
                };
            };
        };

        // Bottom - Custom groups
        class DMORBAT_Grp_TaskGroupsSelection: DMORBAT_Controls_Group {
            idc = IDC_GRP_TASK_GROUPS;  
    
            x = safezoneX + (20 * pixelGridNoUIScale * pixelW);
            y = SafeZoneY + (SafeZoneH - (16 * pixelGridNoUIScale * pixelH));
            w = (safezoneW - (20 * pixelGridNoUIScale * pixelW));
            h = safezoneY + (SafeZoneH - (16 * pixelGridNoUIScale * pixelH));
        
            class Controls {

                // Group 1
                class DMORBAT_TaskGroupsSelectionGrp1: DMORBAT_Controls_Group {
                    idc = IDC_GRP_TASK_GROUP1;  
            
                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 0 * pixelGridNoUIScale * pixelH;
                    w = 20 * pixelGridNoUIScale * pixelW;
                    h = 20 * pixelGridNoUIScale * pixelH;

                    class Controls {
                        class DMORBAT_TaskGroupListTitleGrp1:DMORBAT_StaticText
                        {
                            idc = IDC_TITLE_GROUP1;

                            x = 0.5 * pixelGridNoUIScale * pixelW;
                            y = 0.35 * pixelGridNoUIScale * pixelH;
                            w = 18 * pixelGridNoUIScale * pixelW;
                            h = 2 * pixelGridNoUIScale * pixelH;

                            colorText[] = {1,1,1,1};
                            colorBackground[] = {0.2,0.2,0.2,0};
                            text = "";
                            font = GUI_FONT_BOLD;
                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.75) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_TaskPlayerGroupList:DMORBAT_Tree
                        {
                            idc = IDC_TREE_PLAYER_GRP1;

                            x = 0.5 * pixelGridNoUIScale * pixelW;
                            y = 2.5 * pixelGridNoUIScale * pixelH;
                            w = 19 * pixelGridNoUIScale * pixelW;
                            h = 10 * pixelGridNoUIScale * pixelH;

                            tooltip = "";
                            sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                            multiselectEnabled = 0; // Allow selecting multiple items while holding Ctrl or Shift
                            expandOnDoubleclick = 1; // Expand/collapse item upon double-click
                            maxHistoryDelay = 1; // Time since last keyboard type search to reset it
                        };

                        class DMORBAT_TaskGroupListGrp1:DMORBAT_Tree
                        {
                            idc = IDC_TREE_GRP1;

                            x = 0.5 * pixelGridNoUIScale * pixelW;
                            y = 2.5 * pixelGridNoUIScale * pixelH;
                            w = 19 * pixelGridNoUIScale * pixelW;
                            h = 10 * pixelGridNoUIScale * pixelH;

                            tooltip = "";
                            sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                            multiselectEnabled = 0; // Allow selecting multiple items while holding Ctrl or Shift
                            expandOnDoubleclick = 1; // Expand/collapse item upon double-click
                            maxHistoryDelay = 1; // Time since last keyboard type search to reset it
                        };

                        class DMORBAT_BT_RemoveUnitGrp1:DMORBAT_NoBorderButton
                        {
                            idc = IDC_BT_1_GRP1;

                            x = 0.5 * pixelGridNoUIScale * pixelW;
                            y = 13 * pixelGridNoUIScale * pixelH;
                            w = 4.5 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            text = "";
                            sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_BT_MoveUnitUpGrp1:DMORBAT_NoBorderButton
                        {
                            idc = IDC_BT_2_GRP1;

                            x = 5.3 * pixelGridNoUIScale * pixelW;
                            y = 13 * pixelGridNoUIScale * pixelH;
                            w = 4.5 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            text = "";
                            sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_BT_MoveUnitDownGrp1:DMORBAT_NoBorderButton
                        {
                            idc = IDC_BT_3_GRP1;

                            x = 10.1 * pixelGridNoUIScale * pixelW;
                            y = 13 * pixelGridNoUIScale * pixelH;
                            w = 4.5 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            text = "";
                            sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_BT_PlayerUnitGrp1:DMORBAT_NoBorderButton
                        {
                            idc = IDC_BT_4_GRP1;

                            x = 14.9 * pixelGridNoUIScale * pixelW;
                            y = 13 * pixelGridNoUIScale * pixelH;
                            w = 4.5 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            text = "";
                            sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };
                    };
                };

                // Group 2
                class DMORBAT_TaskGroupsSelectionGrp2: DMORBAT_Controls_Group {
                    idc = IDC_GRP_TASK_GROUP2;  
            
                    x = 20 * pixelGridNoUIScale * pixelW;
                    y = 0 * pixelGridNoUIScale * pixelH;
                    w = 20 * pixelGridNoUIScale * pixelW;
                    h = 20 * pixelGridNoUIScale * pixelH;

                    class Controls {
                        class DMORBAT_TaskGroupListTitleGrp2:DMORBAT_StaticText
                        {
                            idc = IDC_TITLE_GROUP2;

                            x = 0.5 * pixelGridNoUIScale * pixelW;
                            y = 0.35 * pixelGridNoUIScale * pixelH;
                            w = 18 * pixelGridNoUIScale * pixelW;
                            h = 2 * pixelGridNoUIScale * pixelH;

                            colorText[] = {1,1,1,1};
                            colorBackground[] = {0.2,0.2,0.2,0};
                            text = "";
                            font = GUI_FONT_BOLD;
                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.75) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_TaskGroupListGrp2:DMORBAT_Tree
                        {
                            idc = IDC_TREE_GRP2;

                            x = 0.5 * pixelGridNoUIScale * pixelW;
                            y = 2.5 * pixelGridNoUIScale * pixelH;
                            w = 19 * pixelGridNoUIScale * pixelW;
                            h = 10 * pixelGridNoUIScale * pixelH;

                            tooltip = "";
                            sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                            multiselectEnabled = 0; // Allow selecting multiple items while holding Ctrl or Shift
                            expandOnDoubleclick = 1; // Expand/collapse item upon double-click
                            maxHistoryDelay = 1; // Time since last keyboard type search to reset it
                        };

                        class DMORBAT_BT_RemoveUnitGrp2:DMORBAT_NoBorderButton
                        {
                            idc = IDC_BT_1_GRP2;

                            x = 0.5 * pixelGridNoUIScale * pixelW;
                            y = 13 * pixelGridNoUIScale * pixelH;
                            w = 4.5 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            text = "";
                            sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_BT_MoveUnitUpGrp2:DMORBAT_NoBorderButton
                        {
                            idc = IDC_BT_2_GRP2;

                            x = 5.3 * pixelGridNoUIScale * pixelW;
                            y = 13 * pixelGridNoUIScale * pixelH;
                            w = 4.5 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            text = "";
                            sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_BT_MoveUnitDownGrp2:DMORBAT_NoBorderButton
                        {
                            idc = IDC_BT_3_GRP2;

                            x = 10.1 * pixelGridNoUIScale * pixelW;
                            y = 13 * pixelGridNoUIScale * pixelH;
                            w = 4.5 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            text = "";
                            sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_BT_PlayerUnitGrp2:DMORBAT_NoBorderButton
                        {
                            idc = IDC_BT_4_GRP2;

                            x = 14.9 * pixelGridNoUIScale * pixelW;
                            y = 13 * pixelGridNoUIScale * pixelH;
                            w = 4.5 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            text = "";
                            sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };
                    };
                };

                // Group 3
                class DMORBAT_TaskGroupsSelectionGrp32: DMORBAT_Controls_Group {
                    idc = IDC_GRP_TASK_GROUP3;  
            
                    x = 40 * pixelGridNoUIScale * pixelW;
                    y = 0 * pixelGridNoUIScale * pixelH;
                    w = 20 * pixelGridNoUIScale * pixelW;
                    h = 20 * pixelGridNoUIScale * pixelH;

                    class Controls {
                        class DMORBAT_TaskGroupListTitleGrp3:DMORBAT_StaticText
                        {
                            idc = IDC_TITLE_GROUP3;

                            x = 0.5 * pixelGridNoUIScale * pixelW;
                            y = 0.35 * pixelGridNoUIScale * pixelH;
                            w = 18 * pixelGridNoUIScale * pixelW;
                            h = 2 * pixelGridNoUIScale * pixelH;

                            colorText[] = {1,1,1,1};
                            colorBackground[] = {0.2,0.2,0.2,0};
                            text = "";
                            font = GUI_FONT_BOLD;
                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.75) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_TaskGroupListGrp3:DMORBAT_Tree
                        {
                            idc = IDC_TREE_GRP3;

                            x = 0.5 * pixelGridNoUIScale * pixelW;
                            y = 2.5 * pixelGridNoUIScale * pixelH;
                            w = 19 * pixelGridNoUIScale * pixelW;
                            h = 10 * pixelGridNoUIScale * pixelH;

                            tooltip = "";
                            sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                            multiselectEnabled = 0; // Allow selecting multiple items while holding Ctrl or Shift
                            expandOnDoubleclick = 1; // Expand/collapse item upon double-click
                            maxHistoryDelay = 1; // Time since last keyboard type search to reset it
                        };

                        class DMORBAT_BT_RemoveUnitGrp3:DMORBAT_NoBorderButton
                        {
                            idc = IDC_BT_1_GRP3;

                            x = 0.5 * pixelGridNoUIScale * pixelW;
                            y = 13 * pixelGridNoUIScale * pixelH;
                            w = 4.5 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            text = "";
                            sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_BT_MoveUnitUpGrp3:DMORBAT_NoBorderButton
                        {
                            idc = IDC_BT_2_GRP3;

                            x = 5.3 * pixelGridNoUIScale * pixelW;
                            y = 13 * pixelGridNoUIScale * pixelH;
                            w = 4.5 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            text = "";
                            sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_BT_MoveUnitDownGrp3:DMORBAT_NoBorderButton
                        {
                            idc = IDC_BT_3_GRP3;

                            x = 10.1 * pixelGridNoUIScale * pixelW;
                            y = 13 * pixelGridNoUIScale * pixelH;
                            w = 4.5 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            text = "";
                            sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_BT_PlayerUnitGrp3:DMORBAT_NoBorderButton
                        {
                            idc = IDC_BT_4_GRP3;

                            x = 14.9 * pixelGridNoUIScale * pixelW;
                            y = 13 * pixelGridNoUIScale * pixelH;
                            w = 4.5 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            text = "";
                            sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };
                    };
                };
            };
        };

        // Left - Global settings
        class DMORBAT_Grp_EnvSettings: DMORBAT_Controls_Group {
            idc = IDC_GRP_ENVSETTINGS;      
            x = SafeZoneX + (0 * pixelGridNoUIScale * pixelW);
            y = SafeZoneY + (0 * pixelGridNoUIScale * pixelH);
            w = (20 * pixelGridNoUIScale * pixelW);
            h = safezoneH - (10 * pixelGridNoUIScale * pixelH);
        
            class Controls {
                class DMORBAT_Title_EnvSettings_BckgHStrip1:RscPicture
                {
                    idc = -1;

                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 5.5 * pixelGridNoUIScale * pixelH;
                    w = 2 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                class DMORBAT_Title_EnvSettings_BckgHStrip2:RscPicture
                {
                    idc = -1;

                    x = 2 * pixelGridNoUIScale * pixelW;
                    y = 5.5 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
                };

                class DMORBAT_Title_EnvSettings_BckgHStrip3:RscPicture
                {
                    idc = -1;

                    x = 18 * pixelGridNoUIScale * pixelW;
                    y = 5.5 * pixelGridNoUIScale * pixelH;
                    w = 0.5 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                class DMORBAT_Title_EnvSettings_TimeDate:DMORBAT_StaticText
                {
                    idc = IDC_TITLE_ENVSETTINGS_TIMEDATE;

                    x = 2 * pixelGridNoUIScale * pixelW;
                    y = 5.6 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;

                    text = "";
                    font = GUI_FONT_BOLD;
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.75) * 0.5;
                    colorText[] = {1,1,1,1};
                    colorBackground[] = {1,0.5,0,0};
                    tooltip = "";
                };

                // Time and date
                class DMORBAT_Grp_EnvSettings_TimeDate: DMORBAT_Controls_Group {
                    idc = IDC_GRP_ENVSETTINGS_TIMEDATE;     
                    x = 2.5 * pixelGridNoUIScale * pixelW;
                    y = 8 * pixelGridNoUIScale * pixelH;
                    w = (16 * pixelGridNoUIScale * pixelW);
                    h = 10 * pixelGridNoUIScale * pixelH;
                
                    class Controls {
                        
                        // Date
                        class DMORBAT_Bckg_EnvSettings_Date:RscPicture
                        {
                            idc = IDC_BCKG_ENVSETTINGS_DATE;

                            x = 0 * pixelGridNoUIScale * pixelW;
                            y = 0 * pixelGridNoUIScale * pixelH;
                            w = 16 * pixelGridNoUIScale * pixelW;
                            h = 3.7 * pixelGridNoUIScale * pixelH;
                            
                            text = "#(rgb,8,8,3)color(0.4,0.4,0.4,1)";
                        };

                        class DMORBAT_Title_EnvSettings_Date:DMORBAT_StaticText
                        {
                            idc = IDC_TITLE_ENVSETTINGS_DATE;

                            x = 0.5 * pixelGridNoUIScale * pixelW;
                            y = 0.2 * pixelGridNoUIScale * pixelH;
                            w = 12 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            colorText[] = {1,1,1,1};
                            colorBackground[] = {0.2,0.2,0.2,0};
                            text = "";
                            font = GUI_FONT_BOLD;
                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_Combo_EnvSettings_Time_Day:DMORBAT_Combo
                        {
                            idc = IDC_COMBO_ENVSETTINGS_DAY;

                            x = 1.9 * pixelGridNoUIScale * pixelW;
                            y = 1.7 * pixelGridNoUIScale * pixelH;
                            w = 3.5 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;    
                            rowHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
                            wholeHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_Combo_EnvSettings_Time_Month:DMORBAT_Combo
                        {
                            idc = IDC_COMBO_ENVSETTINGS_MONTH;

                            x = 5.8 * pixelGridNoUIScale * pixelW;
                            y = 1.7 * pixelGridNoUIScale * pixelH;
                            w = 4 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;    
                            rowHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
                            wholeHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_Combo_EnvSettings_Time_Year:DMORBAT_Combo
                        {
                            idc = IDC_COMBO_ENVSETTINGS_YEAR;

                            x = 10.2 * pixelGridNoUIScale * pixelW;
                            y = 1.7 * pixelGridNoUIScale * pixelH;
                            w = 4.5 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;    
                            rowHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
                            wholeHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 25) * 0.5;
                            tooltip = "";
                        };


                        // Time
                        class DMORBAT_Bckg_EnvSettings_Time:RscPicture
                        {
                            idc = IDC_BCKG_ENVSETTINGS_TIME;

                            x = 0 * pixelGridNoUIScale * pixelW;
                            y = 4.3 * pixelGridNoUIScale * pixelH;
                            w = 16 * pixelGridNoUIScale * pixelW;
                            h = 5 * pixelGridNoUIScale * pixelH;
                            
                            text = "#(rgb,8,8,3)color(0.4,0.4,0.4,1)";
                        };

                        class DMORBAT_Title_EnvSettings_Time:DMORBAT_StaticText
                        {
                            idc = IDC_TITLE_ENVSETTINGS_TIME;

                            x = 0.5 * pixelGridNoUIScale * pixelW;
                            y = 4.5 * pixelGridNoUIScale * pixelH;
                            w = 12 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            colorText[] = {1,1,1,1};
                            colorBackground[] = {0.2,0.2,0.2,0};
                            text = "";
                            font = GUI_FONT_BOLD;
                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_Combo_EnvSettings_Time_Hour:DMORBAT_Combo
                        {
                            idc = IDC_COMBO_ENVSETTINGS_HOUR;

                            x = 4 * pixelGridNoUIScale * pixelW;
                            y = 6 * pixelGridNoUIScale * pixelH;
                            w = 3.5 * pixelGridNoUIScale * pixelW;
                            h = 1.2 * pixelGridNoUIScale * pixelH;

                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;    
                            rowHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
                            wholeHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_Combo_EnvSettings_Time_Minutes:DMORBAT_Combo
                        {
                            idc = IDC_COMBO_ENVSETTINGS_MINUTES;

                            x = 7.9 * pixelGridNoUIScale * pixelW;
                            y = 6 * pixelGridNoUIScale * pixelH;
                            w = 3.5 * pixelGridNoUIScale * pixelW;
                            h = 1.2 * pixelGridNoUIScale * pixelH;

                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;    
                            rowHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
                            wholeHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_Chk_EnvSettings_RandomTime:DMORBAT_Checkbox
                        {
                            idc = IDC_CHK_ENVSETTINGS_RANDOMTIME;

                            x = 1 * pixelGridNoUIScale * pixelW;
                            y = 7.5 * pixelGridNoUIScale * pixelH;
                            w = 1.5 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            tooltip = "";
                        };

                        class DMORBAT_Txt_EnvSettings_RandomTime:DMORBAT_StaticText
                        {
                            idc = IDC_TXT_ENVSETTINGS_RANDOMTIME;

                            x = 2.5 * pixelGridNoUIScale * pixelW;
                            y = 7.6 * pixelGridNoUIScale * pixelH;
                            w = 6 * pixelGridNoUIScale * pixelW;
                            h = 1 * pixelGridNoUIScale * pixelH;

                            colorText[] = {1,1,1,1};
                            colorBackground[] = {0.2,0.2,0.2,0};
                            text = "";
                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_Chk_EnvSettings_ExcludeNight:DMORBAT_Checkbox
                        {
                            idc = IDC_CHK_ENVSETTINGS_EXCLUDENIGHT;

                            x = 8 * pixelGridNoUIScale * pixelW;
                            y = 7.5 * pixelGridNoUIScale * pixelH;
                            w = 1.5 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            tooltip = "";
                        };

                        class DMORBAT_Txt_EnvSettings_ExcludeNight:DMORBAT_StaticText
                        {
                            idc = IDC_TXT_ENVSETTINGS_EXCLUDENIGHT;

                            x = 9.5 * pixelGridNoUIScale * pixelW;
                            y = 7.6 * pixelGridNoUIScale * pixelH;
                            w = 6 * pixelGridNoUIScale * pixelW;
                            h = 1 * pixelGridNoUIScale * pixelH;

                            colorText[] = {1,1,1,1};
                            colorBackground[] = {0.2,0.2,0.2,0};
                            text = "";
                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };
                    };
                };

                class DMORBAT_Title_EnvSettings_Weather_BckgHStrip1:RscPicture
                {
                    idc = -1;

                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 18 * pixelGridNoUIScale * pixelH;
                    w = 2 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                class DMORBAT_Title_EnvSettings_Weather_BckgHStrip2:RscPicture
                {
                    idc = -1;

                    x = 2 * pixelGridNoUIScale * pixelW;
                    y = 18 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
                };

                class DMORBAT_Title_EnvSettings_Weather_BckgHStrip3:RscPicture
                {
                    idc = -1;

                    x = 18 * pixelGridNoUIScale * pixelW;
                    y = 18 * pixelGridNoUIScale * pixelH;
                    w = 0.5 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                class DMORBAT_Title_EnvSettings_Weather:DMORBAT_StaticText
                {
                    idc = IDC_TITLE_ENVSETTINGS_WEATHERMAIN;

                    x = 2 * pixelGridNoUIScale * pixelW;
                    y = 18.1 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;

                    text = "";
                    font = GUI_FONT_BOLD;
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.75) * 0.5;
                    colorText[] = {1,1,1,1};
                    colorBackground[] = {1,0.5,0,0};
                    tooltip = "";
                };

                // Weather
                class DMORBAT_Grp_EnvSettings_Weather: DMORBAT_Controls_Group {
                    idc = IDC_GRP_ENVSETTINGS_WEATHER;      
                    x = 2.5 * pixelGridNoUIScale * pixelW;
                    y = 19 * pixelGridNoUIScale * pixelH;
                    w = (16 * pixelGridNoUIScale * pixelW);
                    h = 12 * pixelGridNoUIScale * pixelH;
                
                    class Controls {
                        
                        class DMORBAT_Bckg_EnvSettings_Weather:RscPicture
                        {
                            idc = IDC_BCKG_ENVSETTINGS_WEATHER;

                            x = 0 * pixelGridNoUIScale * pixelW;
                            y = 1.5 * pixelGridNoUIScale * pixelH;
                            w = 16 * pixelGridNoUIScale * pixelW;
                            h = 10 * pixelGridNoUIScale * pixelH;
                            
                            text = "#(rgb,8,8,3)color(0.4,0.4,0.4,1)";
                        };

                        class DMORBAT_Title_EnvSettings_Weather:DMORBAT_StaticText
                        {
                            idc = IDC_TITLE_ENVSETTINGS_WEATHER;

                            x = 0.5 * pixelGridNoUIScale * pixelW;
                            y = 1.7 * pixelGridNoUIScale * pixelH;
                            w = 12 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            colorText[] = {1,1,1,1};
                            colorBackground[] = {0.2,0.2,0.2,0};
                            text = "";
                            font = GUI_FONT_BOLD;
                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_Txt_EnvSettings_Overcast:DMORBAT_StaticText
                        {
                            idc = IDC_TXT_ENVSETTINGS_OVERCAST;

                            x = 4.5 * pixelGridNoUIScale * pixelW;
                            y = 3 * pixelGridNoUIScale * pixelH;
                            w = 6 * pixelGridNoUIScale * pixelW;
                            h = 1.25 * pixelGridNoUIScale * pixelH;

                            colorText[] = {1,1,1,1};
                            colorBackground[] = {0.2,0.2,0.2,0};
                            text = "";
                            style = ST_CENTER;
                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_Slider_EnvSettings_Overcast:RscXSliderH
                        {
                            idc = IDC_SLIDER_ENVSETTINGS_OVERCAST;

                            x = 1 * pixelGridNoUIScale * pixelW;
                            y = 4.5 * pixelGridNoUIScale * pixelH;
                            w = 14 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;
                        };

                        class DMORBAT_Txt_EnvSettings_Fog:DMORBAT_StaticText
                        {
                            idc = IDC_TXT_ENVSETTINGS_FOG;

                            x = 4.5 * pixelGridNoUIScale * pixelW;
                            y = 6 * pixelGridNoUIScale * pixelH;
                            w = 6.5 * pixelGridNoUIScale * pixelW;
                            h = 1.25 * pixelGridNoUIScale * pixelH;

                            colorText[] = {1,1,1,1};
                            colorBackground[] = {0.2,0.2,0.2,0};
                            text = "";
                            style = ST_CENTER;
                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_Slider_EnvSettings_Fog:RscXSliderH
                        {
                            idc = IDC_SLIDER_ENVSETTINGS_FOG;

                            x = 1 * pixelGridNoUIScale * pixelW;
                            y = 7.5 * pixelGridNoUIScale * pixelH;
                            w = 14 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;
                        };

                        class DMORBAT_Chk_EnvSettings_RandomWeather:DMORBAT_Checkbox
                        {
                            idc = IDC_CHK_ENVSETTINGS_RANDOMWEATHER;

                            x = 3.5 * pixelGridNoUIScale * pixelW;
                            y = 9.5 * pixelGridNoUIScale * pixelH;
                            w = 1.5 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            tooltip = "";
                        };

                        class DMORBAT_Txt_EnvSettings_RandomWeather:DMORBAT_StaticText
                        {
                            idc = IDC_TXT_ENVSETTINGS_RANDOMWEATHER;

                            x = 5 * pixelGridNoUIScale * pixelW;
                            y = 9.6 * pixelGridNoUIScale * pixelH;
                            w = 8 * pixelGridNoUIScale * pixelW;
                            h = 1 * pixelGridNoUIScale * pixelH;

                            colorText[] = {1,1,1,1};
                            colorBackground[] = {0.2,0.2,0.2,0};
                            text = "";
                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };
                    };
                };

                // Weather Effects
                class DMORBAT_Grp_EnvSettings_WeatherEffects: DMORBAT_Controls_Group {
                    idc = IDC_GRP_ENVSETTINGS_WEATHEREFFECTS;      
                    x = 2.5 * pixelGridNoUIScale * pixelW;
                    y = 29.5 * pixelGridNoUIScale * pixelH;
                    w = (16 * pixelGridNoUIScale * pixelW);
                    h = 5.5 * pixelGridNoUIScale * pixelH;
                
                    class Controls {
                        
                        class DMORBAT_Bckg_EnvSettings_Weather:RscPicture
                        {
                            idc = IDC_BCKG_ENVSETTINGS_WEATHEREFFECTS;

                            x = 0 * pixelGridNoUIScale * pixelW;
                            y = 1.5 * pixelGridNoUIScale * pixelH;
                            w = 16 * pixelGridNoUIScale * pixelW;
                            h = 3.8 * pixelGridNoUIScale * pixelH;
                            
                            text = "#(rgb,8,8,3)color(0.4,0.4,0.4,1)";
                        };

                        class DMORBAT_Title_EnvSettings_WeatherEffects:DMORBAT_StaticText
                        {
                            idc = IDC_TITLE_ENVSETTINGS_WEATHEREFFECTS;

                            x = 0.5 * pixelGridNoUIScale * pixelW;
                            y = 1.7 * pixelGridNoUIScale * pixelH;
                            w = 12 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            colorText[] = {1,1,1,1};
                            colorBackground[] = {0.2,0.2,0.2,0};
                            text = "";
                            font = GUI_FONT_BOLD;
                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_Combo_EnvSettings_WeatherEffects:DMORBAT_Combo
                        {
                            idc = IDC_COMBO_ENVSETTINGS_WEATHEREFFECTS;

                            x = 1 * pixelGridNoUIScale * pixelW;
                            y = 3.2 * pixelGridNoUIScale * pixelH;
                            w = 14 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5; 
                            rowHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 1) * 0.5;
                            wholeHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 25) * 0.5;
                            tooltip = "";
                        };
                    };
                };

                class DMORBAT_Title_EnvSettings_Misc_BckgHStrip1:RscPicture
                {
                    idc = -1;

                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 35.5 * pixelGridNoUIScale * pixelH;
                    w = 2 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                class DMORBAT_Title_EnvSettings_Misc_BckgHStrip2:RscPicture
                {
                    idc = -1;

                    x = 2 * pixelGridNoUIScale * pixelW;
                    y = 35.5 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
                };

                class DMORBAT_Title_EnvSettings_Misc_BckgHStrip3:RscPicture
                {
                    idc = -1;

                    x = 18 * pixelGridNoUIScale * pixelW;
                    y = 35.5 * pixelGridNoUIScale * pixelH;
                    w = 0.5 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };

                class DMORBAT_Title_EnvSettings_Misc:DMORBAT_StaticText
                {
                    idc = IDC_TITLE_ENVSETTINGS_MISC;

                    x = 2 * pixelGridNoUIScale * pixelW;
                    y = 35.51 * pixelGridNoUIScale * pixelH;
                    w = 16 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;

                    text = "";
                    font = GUI_FONT_BOLD;
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.75) * 0.5;
                    colorText[] = {1,1,1,1};
                    colorBackground[] = {1,0.5,0,0};
                    tooltip = "";
                };

                // Misc settings
                class DMORBAT_Grp_EnvSettings_Misc: DMORBAT_Controls_Group {
                    idc = IDC_GRP_ENVSETTINGS_MISC;     
                    x = 2.5 * pixelGridNoUIScale * pixelW;
                    y = 36.5 * pixelGridNoUIScale * pixelH;
                    w = (16 * pixelGridNoUIScale * pixelW);
                    h = 7 * pixelGridNoUIScale * pixelH;
                
                    class Controls {
                        
                        class DMORBAT_Bckg_EnvSettings_Misc:RscPicture
                        {
                            idc = IDC_BCKG_ENVSETTINGS_MISC;

                            x = 0 * pixelGridNoUIScale * pixelW;
                            y = 1.5 * pixelGridNoUIScale * pixelH;
                            w = 16 * pixelGridNoUIScale * pixelW;
                            h = 5 * pixelGridNoUIScale * pixelH;
                            
                            text = "#(rgb,8,8,3)color(0.4,0.4,0.4,1)";
                        };

                        class DMORBAT_Bckg_EnvSettings_forceFlashlights:DMORBAT_Checkbox
                        {
                            idc = IDC_CHK_ENVSETTINGS_FORCEFLASHLIGHTS;

                            x = 1.5 * pixelGridNoUIScale * pixelW;
                            y = 2.5 * pixelGridNoUIScale * pixelH;
                            w = 1.5 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            tooltip = "";
                        };

                        class DMORBAT_Txt_EnvSettings_forceFlashlights:DMORBAT_StaticText
                        {
                            idc = IDC_TXT_ENVSETTINGS_FORCEFLASHLIGHTS;

                            x = 3 * pixelGridNoUIScale * pixelW;
                            y = 2.6 * pixelGridNoUIScale * pixelH;
                            w = 8 * pixelGridNoUIScale * pixelW;
                            h = 1 * pixelGridNoUIScale * pixelH;

                            colorText[] = {1,1,1,1};
                            colorBackground[] = {0.2,0.2,0.2,0};
                            text = "";
                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_Bckg_EnvSettings_flares:DMORBAT_Checkbox
                        {
                            idc = IDC_CHK_ENVSETTINGS_FLARES;

                            x = 1.5 * pixelGridNoUIScale * pixelW;
                            y = 4 * pixelGridNoUIScale * pixelH;
                            w = 1.5 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            tooltip = "";
                        };

                        class DMORBAT_Txt_EnvSettings_flares:DMORBAT_StaticText
                        {
                            idc = IDC_TXT_ENVSETTINGS_FLARES;

                            x = 3 * pixelGridNoUIScale * pixelW;
                            y = 4.1 * pixelGridNoUIScale * pixelH;
                            w = 8 * pixelGridNoUIScale * pixelW;
                            h = 1 * pixelGridNoUIScale * pixelH;

                            colorText[] = {1,1,1,1};
                            colorBackground[] = {0.2,0.2,0.2,0};
                            text = "";
                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };
                    };
                };
            };
        };

        // ---- MENUS - TOP AREA ----

        // Task description
        class DMORBAT_Grp_TaskDescriptionGroup: RscControlsGroupNoScrollbars {
            idc = IDC_GRP_TASK_DESCRIPTION; 

            x = safezoneX + (20 * pixelGridNoUIScale * pixelW);
            y = safezoneY + (0 * pixelGridNoUIScale * pixelH);
            w = safezoneX + (safezoneW + (20 * pixelGridNoUIScale * pixelW));
            h = (11 * pixelGridNoUIScale * pixelH);
        
            class Controls {
                // Background: height 11px total
                class DMORBAT_TaskDescriptionGroupBckg1:RscPicture
                {
                    idc = -1;
                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 0 * pixelGridNoUIScale * pixelH;
                    w = (safezoneW - (20 * pixelGridNoUIScale * pixelW));
                    h = 3 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(1,0.5,0,1)";
                };
                class DMORBAT_TaskDescriptionGroupBckg2:RscPicture
                {
                    idc = -1;
                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 3 * pixelGridNoUIScale * pixelH;
                    w = safezoneW - (20 * pixelGridNoUIScale * pixelW); 
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(0.3,0.3,0.3,1)";
                };
                class DMORBAT_TaskDescriptionGroupBckg3:RscPicture
                {
                    idc = -1;
                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 5 * pixelGridNoUIScale * pixelH;
                    w = safezoneW - (20 * pixelGridNoUIScale * pixelW); 
                    h = 6 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
                };
                class DMORBAT_TaskDescriptionGroupTitle:DMORBAT_StaticText
                {
                    idc = IDC_TITLE_TASK_DESCRIPTION_GROUP;

                    x = 1 * pixelGridNoUIScale * pixelW;
                    y = 1 * pixelGridNoUIScale * pixelH;
                    w = (safezoneW - (45 * pixelGridNoUIScale * pixelW));   
                    h = 4 * pixelGridNoUIScale * pixelH;

                    colorText[] = {1,1,1,1};
                    colorBackground[] = {0.2,0.2,0.2,0};
                    text = "";
                    font = GUI_FONT_BOLD;
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 2) * 0.5;
                    tooltip = "";
                };
                class DMORBAT_TaskDescriptionGroupTxt:DMORBAT_StaticText
                {
                    idc = IDC_TXT_TASK_DESCRIPTION_GROUP;

                    x = 1 * pixelGridNoUIScale * pixelW;
                    y = 6 * pixelGridNoUIScale * pixelH;
                    w = (safezoneW - (22 * pixelGridNoUIScale * pixelW));   
                    h = 4 * pixelGridNoUIScale * pixelH;

                    colorText[] = {1,1,1,1};
                    colorBackground[] = {0.2,0.2,0.2,0};
                    text = "";
                    font = GUI_FONT_MONO;
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 0.9) * 0.5;
                    tooltip = "";
                };
            };
        };

		// Current saved data display
		class DMORBAT_Grp_CurrentSavedData: DMORBAT_Controls_Group {
			idc = IDC_GRP_CURRENTSAVEDDATA;	
	
			x = SafeZoneX + (SafeZoneW - (20 * pixelGridNoUIScale * pixelW));
			y = SafeZoneY + (1 * pixelGridNoUIScale * pixelH);
			w = 20 * pixelGridNoUIScale * pixelW;
			h = 2 * pixelGridNoUIScale * pixelH;

			class Controls {
				class DMORBAT_Bckg_CurrentSavedData:RscPicture
				{
					idc = -1;
					x = 0 * pixelGridNoUIScale * pixelW;
					y = 0 * pixelGridNoUIScale * pixelH;
					w = 20 * pixelGridNoUIScale * pixelW;	
					h = 2 * pixelGridNoUIScale * pixelH;
					
					text = "#(rgb,8,8,3)color(0.2,0.2,0.2,1)";
				};
				class DMORBAT_Txt_CurrentSavedData:DMORBAT_StaticText
				{
					idc = IDC_TXT_CURRENTSAVEDDATA;
					colorText[] = {1,1,1,1};
					colorBackground[] = {0.2,0.2,0.2,0};

					x = 1.5 * pixelGridNoUIScale * pixelW;
					y = 0.5 * pixelGridNoUIScale * pixelH;
					w = 18 * pixelGridNoUIScale * pixelW;
					h = 1 * pixelGridNoUIScale * pixelH;

					text = "";
					font = GUI_FONT_MONO;
				    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1) * 0.5;

					tooltip = "";
				};
				class DMORBAT_BT_CurrentSavedData_Open:DMORBAT_InvisibleButton
				{
					idc = IDC_BT_CURRENTSAVEDDATA_OPEN;
					x = 0 * pixelGridNoUIScale * pixelW;
					y = 0 * pixelGridNoUIScale * pixelH;
					w = 20 * pixelGridNoUIScale * pixelW;
					h = 2 * pixelGridNoUIScale * pixelH;

					text = "";
					tooltip = "";
				};
			};
		};

        // ---- BOTTOM LEFT ELEMENTS ----

        // Tips
        class DMORBAT_Tips:DMORBAT_StaticText
        {
            idc = IDC_TXT_TIPS;

            x = SafeZoneX + ((2 * pixelGridNoUIScale * pixelW));
            y = SafeZoneY + (SafeZoneH - (15.5 * pixelGridNoUIScale * pixelH));
            w = (17 * pixelGridNoUIScale * pixelW);
            h = (7 * pixelGridNoUIScale * pixelH);
            
            colorText[] = {1,1,1,1};
            colorBackground[] = {0.2,0.2,0.2,0};
            text = "";
            font = GUI_FONT_MONO;
            style = ST_LEFT + ST_MULTI;
            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 0.8) * 0.5;
            lineSpacing = 1.25;
            tooltip = "";
        };

        // Message Box
        class DMORBAT_MessageBox:DMORBAT_StaticText
        {
            idc = IDC_TXT_MESSAGEBOX;

            x = SafeZoneX + ((2.25 * pixelGridNoUIScale * pixelW));
            y = SafeZoneY + (SafeZoneH - (7.8 * pixelGridNoUIScale * pixelH));
            w = (16.5 * pixelGridNoUIScale * pixelW);
            h = (5 * pixelGridNoUIScale * pixelH);
            
            colorText[] = {1,1,1,1};
            colorBackground[] = {0.2,0.2,0.2,0};
            text = "";
            font = GUI_FONT_MONO;
            style = ST_LEFT + ST_MULTI;
            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 0.8) * 0.5;
            lineSpacing = 1.25;
            tooltip = "";
        };

        // Page navigation buttons
        class DMORBAT_Grp_NavButtons: DMORBAT_Controls_Group {
            idc = IDC_GRP_NAV_BUTTONS;      
            x = SafeZoneX + (0 * pixelGridNoUIScale * pixelW);
            y = SafeZoneY + (SafeZoneH - (2 * pixelGridNoUIScale * pixelH));
            w = (20 * pixelGridNoUIScale * pixelW);
            h = (2 * pixelGridNoUIScale * pixelH);
        
            class Controls {
                class DMORBAT_Grp_NavButtonsBckg:RscPicture
                {
                    idc = -1;
                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 0 * pixelGridNoUIScale * pixelH;
                    w = 19.9 * pixelGridNoUIScale * pixelW; 
                    h = 2 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(0.3,0.3,0.3,1)";
                };

                class DMORBAT_BackButton:DMORBAT_NoBorderButton
                {
                    idc = IDC_BT_BACK;

                    x = 0.1 * pixelGridNoUIScale * pixelW;
                    y = 0 * pixelGridNoUIScale * pixelH;
                    w = 6 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;

                    text = "";
                    sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                    style = ST_CENTER;
                    tooltip = "";
                    colorBackground[] = {1,0.5,0,1}; // Fill color
                    colorBackgroundDisabled[] = {1,0.5,0.5}; // Disabled fill color
                    colorBackgroundActive[] = {0,0,0,1}; // Mouse hover fill color
                    colorFocused[] = {1,0.5,0,1}; // Selected fill color (oscillates between this and colorBackground)
                    offsetX = 0; // Horizontal background frame offset
                    offsetY = 0.01; // Vertical background frame offset
                    offsetPressedX = 0.01; // Horizontal background offset when pressed
                    offsetPressedY = 0; // Vertical background offset when pressed
                };

                class DMORBAT_NextButton:DMORBAT_NoBorderButton
                {
                    idc = IDC_BT_NEXT;

                    x = 13.9 * pixelGridNoUIScale * pixelW;
                    y = 0 * pixelGridNoUIScale * pixelH;
                    w = 6 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;

                    text = "";
                    sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                    style = ST_CENTER;
                    tooltip = "";
                    colorBackground[] = {1,0.5,0,1}; // Fill color
                    colorBackgroundDisabled[] = {1,0.5,0.5}; // Disabled fill color
                    colorBackgroundActive[] = {0,0,0,1}; // Mouse hover fill color
                    colorFocused[] = {1,0.5,0,1}; // Selected fill color (oscillates between this and colorBackground)
                    offsetX = 0; // Horizontal background frame offset
                    offsetY = 0.01; // Vertical background frame offset
                    offsetPressedX = -0.01; // Horizontal background offset when pressed
                    offsetPressedY = 0; // Vertical background offset when pressed
                };
            };
        };

        // ---- POPUPS ----

        // Popup Crew selection
        class DMORBAT_Grp_VehicleCrewSelection: DMORBAT_Controls_Group {
            idc = IDC_GRP_VEH_CREW_SEL; 
    
            x = safezoneX;
            y = safezoneY;
            w = safezoneW;
            h = safezoneH;

            class Controls {
                class DMORBAT_Bckg_VehicleCrewSelectionMain:RscPicture
                {
                    idc = -1;
                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 0 * pixelGridNoUIScale * pixelH;
                    w = safezoneW;  
                    h = safezoneH;
                    
                    text = "#(rgb,8,8,3)color(0,0,0,0.8)";
                };
                class DMORBAT_Grp_VehicleCrewSelectionPopup: DMORBAT_Controls_Group {
                    idc = IDC_GRP_VEH_CREW_SEL_POPUP;   
            
                    x = (safeZoneX + (safeZoneWAbs / 2));
                    y = 30 * pixelGridNoUIScale * pixelH;
                    w = 20 * pixelGridNoUIScale * pixelW;
                    h = 9 * pixelGridNoUIScale * pixelH;

                    class Controls {
                        class DMORBAT_TaskGroupCrewBckg:RscPicture
                        {
                            idc = -1;
                            x = 0 * pixelGridNoUIScale * pixelW;
                            y = 0 * pixelGridNoUIScale * pixelH;
                            w = 20 * pixelGridNoUIScale * pixelW;   
                            h = 8.5 * pixelGridNoUIScale * pixelH;
                            
                            text = "#(rgb,8,8,3)color(0.3,0.3,0.3,1)";
                        };
                        class DMORBAT_TaskGroupCrewTitle:DMORBAT_StaticText
                        {
                            idc = IDC_TITLE_TASK_GROUPS_CREW;

                            x = 1.5 * pixelGridNoUIScale * pixelW;
                            y = 0.5 * pixelGridNoUIScale * pixelH;
                            w = 18 * pixelGridNoUIScale * pixelW;   
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            colorText[] = {1,1,1,1};
                            colorBackground[] = {0.2,0.2,0.2,0};
                            text = "";
                            font = GUI_FONT_MONO;
                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };
                        class DMORBAT_TaskGroupCrewCombo:DMORBAT_Combo
                        {
                            idc = IDC_COMBO_TASK_GROUPS_CREW;

                            x = 1.5 * pixelGridNoUIScale * pixelW;
                            y = 2.5 * pixelGridNoUIScale * pixelH;
                            w = 17 * pixelGridNoUIScale * pixelW;
                            h = 2 * pixelGridNoUIScale * pixelH;

                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.5) * 0.5; 
                            rowHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 1) * 0.5;
                            wholeHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 25) * 0.5;
                            tooltip = "";
                        };
                        class DMORBAT_BT_AcceptCrewSlot:DMORBAT_Button
                        {
                            idc = IDC_BT_TASK_GROUPS_CREW;
                            x = 6 * pixelGridNoUIScale * pixelW;
                            y = 5.5 * pixelGridNoUIScale * pixelH;
                            w = 6 * pixelGridNoUIScale * pixelW;
                            h = 2 * pixelGridNoUIScale * pixelH;

                            text = "";
                            sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };
                    };
                };
            };
        };

        // Popup Unit edit
        class DMORBAT_Grp_EditUnit: DMORBAT_Controls_Group {
            idc = IDC_GRP_UNITEDIT; 
    
            x = safezoneX;
            y = safezoneY;
            w = safezoneW;
            h = safezoneH;

            class Controls {
                class DMORBAT_Bckg_EditUnitMain:RscPicture
                {
                    idc = -1;
                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 0 * pixelGridNoUIScale * pixelH;
                    w = safezoneW;  
                    h = safezoneH;
                    
                    text = "#(rgb,8,8,3)color(0,0,0,0.8)";
                };

                class DMORBAT_Grp_EditUnitPopup: DMORBAT_Controls_Group {
                    idc = IDC_GRP_UNITEDIT_POPUP;   
            
                    x = (safeZoneX + (safeZoneWAbs / 2));
                    y = 30 * pixelGridNoUIScale * pixelH;
                    w = (20 * pixelGridNoUIScale * pixelW);
                    h = 12 * pixelGridNoUIScale * pixelH;

                    class Controls {
                        class DMORBAT_Bckg_EditUnit:RscPicture
                        {
                            idc = -1;
                            x = 0 * pixelGridNoUIScale * pixelW;
                            y = 0 * pixelGridNoUIScale * pixelH;
                            w = 20 * pixelGridNoUIScale * pixelW;   
                            h = 12 * pixelGridNoUIScale * pixelH;
                            
                            text = "#(rgb,8,8,3)color(0.3,0.3,0.3,1)";

                            colorBackground[] = {0.3,0.3,0.3,1};
                        };
                        class DMORBAT_Title_EditUnit:DMORBAT_StaticText
                        {
                            idc = IDC_TITLE_UNITEDIT;
                            colorText[] = {1,1,1,1};
                            colorBackground[] = {0.2,0.2,0.2,0};

                            x = 1.5 * pixelGridNoUIScale * pixelW;
                            y = 0.5 * pixelGridNoUIScale * pixelH;
                            w = 18 * pixelGridNoUIScale * pixelW;
                            h = 1 * pixelGridNoUIScale * pixelH;

                            text = "";
                            font = GUI_FONT_MONO;
                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1) * 0.5;

                            tooltip = "";
                        };

                        class DMORBAT_Title_EditUnit_Presence:DMORBAT_StaticText
                        {
                            idc = IDC_TITLE_UNITEDIT_PRESENCE;
                            colorText[] = {1,1,1,1};
                            colorBackground[] = {0.2,0.2,0.2,0};

                            x = 1.5 * pixelGridNoUIScale * pixelW;
                            y = 2 * pixelGridNoUIScale * pixelH;
                            w = 18 * pixelGridNoUIScale * pixelW;
                            h = 1 * pixelGridNoUIScale * pixelH;

                            text = "";
                            font = GUI_FONT_MONO;
                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 0.8) * 0.5;

                            tooltip = "";
                        };
                        class DMORBAT_Combo_EditUnit_Presence:DMORBAT_Combo
                        {
                            idc = IDC_COMBO_UNITEDIT_PRESENCE;

                            x = 1.5 * pixelGridNoUIScale * pixelW;
                            y = 3 * pixelGridNoUIScale * pixelH;
                            w = 17 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.1) * 0.5; 
                            rowHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 1) * 0.5;
                            wholeHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 25) * 0.5;

                            tooltip = "";
                        };

                        class DMORBAT_Title_EditUnit_Skill:DMORBAT_StaticText
                        {
                            idc = IDC_TITLE_UNITEDIT_SKILL;
                            colorText[] = {1,1,1,1};
                            colorBackground[] = {0.2,0.2,0.2,0};

                            x = 1.5 * pixelGridNoUIScale * pixelW;
                            y = 5 * pixelGridNoUIScale * pixelH;
                            w = 18 * pixelGridNoUIScale * pixelW;
                            h = 1 * pixelGridNoUIScale * pixelH;

                            text = "";
                            font = GUI_FONT_MONO;
                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 0.8) * 0.5;

                            tooltip = "";
                        };
                        class DMORBAT_Combo_EditUnit_Skill:DMORBAT_Combo
                        {
                            idc = IDC_COMBO_UNITEDIT_SKILL;

                            x = 1.5 * pixelGridNoUIScale * pixelW;
                            y = 6 * pixelGridNoUIScale * pixelH;
                            w = 17 * pixelGridNoUIScale * pixelW;
                            h = 1.5 * pixelGridNoUIScale * pixelH;

                            sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.1) * 0.5; 
                            rowHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 1) * 0.5;
                            wholeHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 25) * 0.5;

                            tooltip = "";
                        };

                        class DMORBAT_BT_EditUnit_OK:DMORBAT_Button
                        {
                            idc = IDC_BT_UNITEDIT_OK;
                            x = 4 * pixelGridNoUIScale * pixelW;
                            y = 8.5 * pixelGridNoUIScale * pixelH;
                            w = 4 * pixelGridNoUIScale * pixelW;
                            h = 2 * pixelGridNoUIScale * pixelH;

                            text = "";
                            sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };

                        class DMORBAT_BT_EditUnit_Cancel:DMORBAT_Button
                        {
                            idc = IDC_BT_UNITEDIT_CANCEL;
                            x = 11 * pixelGridNoUIScale * pixelW;
                            y = 8.5 * pixelGridNoUIScale * pixelH;
                            w = 4 * pixelGridNoUIScale * pixelW;
                            h = 2 * pixelGridNoUIScale * pixelH;

                            text = "";
                            sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                            tooltip = "";
                        };
                    };
                };
            };
        };

		// Popup Rename data
		class DMORBAT_Grp_DataRename: DMORBAT_Controls_Group {
			idc = IDC_GRP_DATARENAME;	
	
			x = safezoneX;
			y = safezoneY;
			w = safezoneW;
			h = safezoneH;

			class Controls {
				class DMORBAT_Bckg_DataRenameMain:RscPicture
				{
					idc = -1;
					x = 0 * pixelGridNoUIScale * pixelW;
					y = 0 * pixelGridNoUIScale * pixelH;
					w = safezoneW;	
					h = safezoneH;
					
					text = "#(rgb,8,8,3)color(0,0,0,0.8)";
				};
				class DMORBAT_Grp_DataRenamePopup: DMORBAT_Controls_Group {
					idc = IDC_GRP_DATARENAME_POPUP;	
			
					x = (safeZoneX + (safeZoneWAbs / 2));
					y = (30 * pixelGridNoUIScale * pixelH);
					w = 20 * pixelGridNoUIScale * pixelW;
					h = 9 * pixelGridNoUIScale * pixelH;

					class Controls {
						class DMORBAT_Bckg_DataRename:RscPicture
						{
							idc = -1;
							x = (0 * pixelGridNoUIScale * pixelW);
							y = (0 * pixelGridNoUIScale * pixelH);
							w = 20 * pixelGridNoUIScale * pixelW;	
							h = 9 * pixelGridNoUIScale * pixelH;
							
							text = "#(rgb,8,8,3)color(0.3,0.3,0.3,1)";
						};
						class DMORBAT_Title_DataRename:DMORBAT_StaticText
						{
							idc = IDC_TITLE_DATARENAME;

							x = (1 * pixelGridNoUIScale * pixelW);
							y = (1 * pixelGridNoUIScale * pixelW);
							w = (18 * pixelGridNoUIScale * pixelW);
							h = (1 * pixelGridNoUIScale * pixelH);

                            colorText[] = {1,1,1,1};
                            colorBackground[] = {0.2,0.2,0.2,0};
							text = "";
							font = GUI_FONT_MONO;
						    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1) * 0.5;
							tooltip = "";
						};

						class DMORBAT_Txt_DataRename:RscEdit
						{
							idc = IDC_TXT_DATARENAME;

							x = (1 * pixelGridNoUIScale * pixelW);
							y = (3 * pixelGridNoUIScale * pixelH);
							w = (18 * pixelGridNoUIScale * pixelW);
							h = 2 * pixelGridNoUIScale * pixelH;

							colorText[] = {0,0,0,1};
							shadow = 0;
							colorBackground[] = {0.5,0.5,0.5,1};
							text = "";
							font = GUI_FONT_MONO;
						    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1) * 0.5;
							tooltip = "";
                            maxChars = 30;
						};

						class DMORBAT_BT_DataRename_OK:DMORBAT_Button
						{
							idc = IDC_BT_DATARENAME_OK;
							x = (4 * pixelGridNoUIScale * pixelW);
							y = (5.5 * pixelGridNoUIScale * pixelH);
							w = 4 * pixelGridNoUIScale * pixelW;
							h = 2 * pixelGridNoUIScale * pixelH;

							text = "";
							sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
							tooltip = "";
						};

						class DMORBAT_BT_DataRename_Cancel:DMORBAT_Button
						{
							idc = IDC_BT_DATARENAME_CANCEL;
							x = (11 * pixelGridNoUIScale * pixelW);
							y = 5.5 * pixelGridNoUIScale * pixelH;
							w = 4 * pixelGridNoUIScale * pixelW;
							h = 2 * pixelGridNoUIScale * pixelH;

							text = "";
							sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
							tooltip = "";
						};
					};
				};
			};
		};

        // Saved data profiles menu
        class DMORBAT_Grp_SavedDataProfiles: DMORBAT_Controls_Group {
            idc = IDC_GRP_SAVEDDATAPROFILES;    
    
            x = SafeZoneX + (SafeZoneW - (20 * pixelGridNoUIScale * pixelW));
            y = SafeZoneY + (3 * pixelGridNoUIScale * pixelH);
            w = 20 * pixelGridNoUIScale * pixelW;
            h = 11 * pixelGridNoUIScale * pixelH;

            class Controls {
                class DMORBAT_Bckg_SavedDataProfiles:RscPicture
                {
                    idc = -1;
                    x = 0 * pixelGridNoUIScale * pixelW;
                    y = 0 * pixelGridNoUIScale * pixelH;
                    w = 20 * pixelGridNoUIScale * pixelW;   
                    h = 11 * pixelGridNoUIScale * pixelH;
                    
                    text = "#(rgb,8,8,3)color(0.3,0.3,0.3,1)";

                };

                class DMORBAT_Title_SavedDataProfiles:DMORBAT_StaticText
                {
                    idc = IDC_TITLE_SAVEDDATAPROFILES;

                    x = 1.5 * pixelGridNoUIScale * pixelW;
                    y = 1 * pixelGridNoUIScale * pixelH;
                    w = 18 * pixelGridNoUIScale * pixelW;
                    h = 1 * pixelGridNoUIScale * pixelH;

                    text = "";
                    font = GUI_FONT_MONO;
                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1) * 0.5;
                    colorText[] = {1,1,1,1};
                    colorBackground[] = {0.2,0.2,0.2,0};
                    tooltip = "";
                };

                class DMORBAT_Combo_SavedDataProfiles:DMORBAT_Combo
                {
                    idc = IDC_COMBO_SAVEDDATAPROFILES;

                    x = 1.5 * pixelGridNoUIScale * pixelW;
                    y = 2.5 * pixelGridNoUIScale * pixelH;
                    w = 17 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    sizeEx = ((pixelH * (pixelGridNoUIScale) * 2) * 1.1) * 0.5; 
                    rowHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 1) * 0.5;
                    wholeHeight = ((pixelH * (pixelGridNoUIScale) * 2) * 25) * 0.5;
                    tooltip = "";
                };

                class DMORBAT_BT_SavedDataProfiles_New:DMORBAT_Button
                {
                    idc = IDC_BT_SAVEDDATAPROFILES_NEW;
                    x = 3 * pixelGridNoUIScale * pixelW;
                    y = 4.5 * pixelGridNoUIScale * pixelH;
                    w = 4 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;

                    text = "";
                    sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                    tooltip = "";
                };

                class DMORBAT_BT_SavedDataProfiles_Rename:DMORBAT_Button
                {
                    idc = IDC_BT_SAVEDDATAPROFILES_RENAME;
                    x = 8 * pixelGridNoUIScale * pixelW;
                    y = 4.5 * pixelGridNoUIScale * pixelH;
                    w = 4 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;

                    text = "";
                    sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                    tooltip = "";
                };

                class DMORBAT_BT_SavedDataProfiles_Delete:DMORBAT_Button
                {
                    idc = IDC_BT_SAVEDDATAPROFILES_DELETE;
                    x = 13 * pixelGridNoUIScale * pixelW;
                    y = 4.5 * pixelGridNoUIScale * pixelH;
                    w = 4 * pixelGridNoUIScale * pixelW;
                    h = 2 * pixelGridNoUIScale * pixelH;

                    text = "";
                    sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                    tooltip = "";
                };

                class DMORBAT_BT_SavedDataProfiles_Import:DMORBAT_NoBorderButton
                {
                    idc = IDC_BT_SAVEDDATAPROFILES_IMPORT;
                    x = 6 * pixelGridNoUIScale * pixelW;
                    y = 8.5 * pixelGridNoUIScale * pixelH;
                    w = 4.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    text = "";
                    sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                    tooltip = "";
                };

                class DMORBAT_BT_SavedDataProfiles_Export:DMORBAT_NoBorderButton
                {
                    idc = IDC_BT_SAVEDDATAPROFILES_EXPORT;
                    x = (11 * pixelGridNoUIScale * pixelW);
                    y = 8.5 * pixelGridNoUIScale * pixelH;
                    w = 4.5 * pixelGridNoUIScale * pixelW;
                    h = 1.5 * pixelGridNoUIScale * pixelH;

                    text = "";
                    sizeEx = ((pixelH * pixelGridNoUIScale * 2) * 1.25) * 0.5;
                    tooltip = "";
                };
            };
        };


	};	
};