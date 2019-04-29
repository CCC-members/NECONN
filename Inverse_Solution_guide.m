classdef Inverse_Solution_guide < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        Inverse_Solutions_PlatformUIFigure  matlab.ui.Figure
        FileMenu                      matlab.ui.container.Menu
        CreatedatastructureMenu       matlab.ui.container.Menu
        DatapathMenu                  matlab.ui.container.Menu
        ExitMenu                      matlab.ui.container.Menu
        ToolsMenu                     matlab.ui.container.Menu
        RunIverseSolutionMethodsMenu  matlab.ui.container.Menu
        SingleSubjectMenu             matlab.ui.container.Menu
        DataBatchingMenu              matlab.ui.container.Menu
        HelpMenu                      matlab.ui.container.Menu
        TextArea                      matlab.ui.control.TextArea
        TabGroup                      matlab.ui.container.TabGroup
        BeamfomerTab                  matlab.ui.container.Tab
        BeamfomerPanel                matlab.ui.container.Panel
        DropDownLabel                 matlab.ui.control.Label
        DropDown                      matlab.ui.control.DropDown
        EditFieldLabel                matlab.ui.control.Label
        EditField                     matlab.ui.control.EditField
        EditField2Label               matlab.ui.control.Label
        EditField2                    matlab.ui.control.EditField
        BMATab                        matlab.ui.container.Tab
        BMAPanel                      matlab.ui.container.Panel
        eLORETATab                    matlab.ui.container.Tab
        eLORETAPanel                  matlab.ui.container.Panel
        ENETMMTab                     matlab.ui.container.Tab
        ENETMMPanel                   matlab.ui.container.Panel
        LASSOMMTab                    matlab.ui.container.Tab
        LASSOMMPanel                  matlab.ui.container.Panel
        ENETSSBLTab                   matlab.ui.container.Tab
        ENETSSBLPanel                 matlab.ui.container.Panel
        sLORETATab                    matlab.ui.container.Tab
        sLORETAPanel                  matlab.ui.container.Panel
        STTONNICATab                  matlab.ui.container.Tab
        STTONNICAPanel                matlab.ui.container.Panel
        MethodsLabel                  matlab.ui.control.Label
        MethodsDropDown               matlab.ui.control.DropDown
        AddButton                     matlab.ui.control.Button
        RunButton                     matlab.ui.control.Button
        DeleteButton                  matlab.ui.control.Button
        ModeDropDownLabel             matlab.ui.control.Label
        ModeDropDown                  matlab.ui.control.DropDown
        BandsDropDown                 matlab.ui.control.DropDown
    end

    
    properties (Access = private)
        Property % Description
    end
    
    properties (Access = public)
        single_subject % Description
        attributes  % Description
        methods_array
        data_path
    end
    
    methods (Access = private)
        
        function setPromptFcn(app,jTextArea,eventData,newPrompt)
            % Prevent overlapping reentry due to prompt replacement
            persistent inProgress
            if isempty(inProgress)
                inProgress = 1;  %#ok unused
            else
                return;
            end
            
            try
                % *** Prompt modification code goes here ***
                cwText = char(jTextArea.getText);
                app.TextArea.Value = cwText;
                % force prompt-change callback to fizzle-out...
                pause(0.02);
            catch
                % Never mind - ignore errors...
            end
            
            % Enable new callbacks now that the prompt has been modified
            inProgress = [];
            
        end  % setPromptFcn
        
    end
    

    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            clc;
            warning off;
            addpath('guide');
            addpath('icon');
            addpath('tools');
            addpath('functions');
            addpath('properties');
            
            set(app.BeamfomerPanel,'Visible','off');
            set(app.BMAPanel,'Visible','off');
            set(app.eLORETAPanel,'Visible','off');
            set(app.ENETMMPanel,'Visible','off');
            set(app.LASSOMMPanel,'Visible','off');            
            set(app.ENETSSBLPanel,'Visible','off');
            set(app.sLORETAPanel,'Visible','off');
            set(app.STTONNICAPanel,'Visible','off');
            
            app.attributes = cell(1,9);
            for i = 1 : 9
                app.attributes{1,i} = ["run","false"];
            end
            
            app.methods_array = ["beamfomer","bma","eloreta","enetmm","lassomm",...
                "enetssbl","sloreta","sttonnica"];
            
            app.data_path = 0;
            try
                jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
                jCmdWin = jDesktop.getClient('Command Window');
                jTextArea = jCmdWin.getComponent(0).getViewport.getView;
                set(jTextArea,'CaretUpdateCallback',@app.setPromptFcn)
            catch
                warndlg('fatal error');
            end
        end

        % Menu selected function: DataBatchingMenu
        function DataBatchingMenuSelected(app, event)
            root_tab =  'properties';
            parameter_name = 'run_single_subject';
            parameter_value = 0;
            change_xml_parameter(strcat('properties',filesep,'properties.xml'),root_tab,parameter_name,parameter_value);
            Main;
            msgbox('Completed operation!!!','Info');
        end

        % Menu selected function: RunIverseSolutionMethodsMenu
        function RunIverseSolutionMethodsMenuSelected(app, event)
            
        end

        % Callback function
        function ButtonPushed(app, event)
            jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
            jCmdWin = jDesktop.getClient('Command Window');
            jTextArea = jCmdWin.getComponent(0).getViewport.getView;
            cwText = char(jTextArea.getText);
            
            set(jTextArea,'CaretUpdateCallback',@myUpdateFcn)
            
        end

        % Menu selected function: ExitMenu
        function ExitMenuSelected(app, event)
            delete(app);
        end

        % Menu selected function: SingleSubjectMenu
        function SingleSubjectMenuSelected(app, event)
            
            root_tab =  'properties';
            parameter_name = 'run_single_subject';
            parameter_value = 1;
            change_xml_parameter(strcat('properties',filesep,'properties.xml'),root_tab,parameter_name,parameter_value);
            Main;
            msgbox('Completed operation!!!','Info');
        end

        % Button pushed function: DeleteButton
        function DeleteButtonPushed(app, event)
            
            
            method_selected = app.MethodsDropDown.Value;
            switch method_selected
                case 'Beamfomer'
                    set(app.BeamfomerPanel,'Visible','off');
                    app.attributes{1,1} = ["run","false"];
                case 'BMA'
                    set(app.BMAPanel,'Visible','off');
                    app.attributes{1,2} = ["run","false"];
                case 'eLORETA'
                    set(app.eLORETAPanel,'Visible','off');
                    app.attributes{1,3} = ["run","false"];
                case 'ENETMM'
                    set(app.ENETMMPanel,'Visible','off');
                    app.attributes{1,4} = ["run","false"];
                case 'LASSOMM'
                    set(app.LASSOMMPanel,'Visible','off');
                    app.attributes{1,5} = ["run","false"];                
                case 'ENETSSBL'
                    set(app.ENETSSBLPanel,'Visible','off');
                    app.attributes{1,7} = ["run","false"];
                case 'sLORETA'
                    set(app.sLORETAPanel,'Visible','off');
                    app.attributes{1,8} = ["run","false"];
                case 'STONICA'
                    set(app.STTONNICAPanel,'Visible','off');
                    app.attributes{1,9} = ["run","false"];
            end
            
        end

        % Button pushed function: AddButton
        function AddButtonPushed(app, event)
            method_selected = app.MethodsDropDown.Value;
            switch method_selected
                case 'Beamfomer'
                    set(app.BeamfomerPanel,'Visible','on');
                    set(app.TabGroup,'SelectedTab',app.BeamfomerTab);
                    app.attributes{1,1} = ["name",method_selected,"run","true"];
                case 'BMA'
                    set(app.BMAPanel,'Visible','on');
                    set(app.TabGroup,'SelectedTab',app.BMATab);
                    app.attributes{1,2} = ["name",method_selected,"run","true"];
                case 'eLORETA'
                    set(app.eLORETAPanel,'Visible','on');
                    set(app.TabGroup,'SelectedTab',app.eLORETATab);
                    app.attributes{1,3} = ["name",method_selected,"run","true"];
                case 'ENET-MM'
                    set(app.ENETMMPanel,'Visible','on');
                    set(app.TabGroup,'SelectedTab',app.ENETMMTab);
                    app.attributes{1,4} = ["name",method_selected,"run","true"];
                case 'LASSO-MM'
                    set(app.LASSOMMPanel,'Visible','on');
                    set(app.TabGroup,'SelectedTab',app.LASSOMMTab);
                    app.attributes{1,5} = ["name",method_selected,"run","true"];               
                case 'ENET-SSBL'
                    set(app.ENETSSBLPanel,'Visible','on');
                    set(app.TabGroup,'SelectedTab',app.ENETSSBLTab);
                    app.attributes{1,7} = ["name",method_selected,"run","true"];
                case 'sLORETA'
                    set(app.sLORETAPanel,'Visible','on');
                    set(app.TabGroup,'SelectedTab',app.sLORETATab);
                    app.attributes{1,8} = ["name",method_selected,"run","true"];
                case 'STTONNICA'
                    set(app.STTONNICAPanel,'Visible','on');
                    set(app.TabGroup,'SelectedTab',app.STTONNICATab);
                    app.attributes{1,9} = ["name",method_selected,"run","true"];
            end
        end

        % Value changed function: ModeDropDown
        function ModeDropDownValueChanged(app, event)
            value = app.ModeDropDown.Value;
            switch value
                case 'Time Domain'
                    set(app.BandsDropDown,'Visible','off');
                case 'Frequency Domain'
                    set(app.BandsDropDown,'Visible','on');
            end
            
        end

        % Button pushed function: RunButton
        function RunButtonPushed(app, event)
            % set_default_properties();
           
            guiHandle = freqresol_maxfreq_samplfreq_guide;
            
            disp('------Waitintg for frequency_bands------');
            uiwait(guiHandle.UIFigure);
            
            if(guiHandle.canceled)
                delete(guiHandle);
                return;
            else
                delete(guiHandle);
            end
            
            if(app.data_path == 0 )
                folder = uigetdir('tittle','Select the Data''s Folder');
                if(folder==0)
                    return;
                end
                app.data_path = folder;
                file_path = strcat('properties',filesep,'properties.xml');
                root_tab =  'properties';
                parameter_name = "data_path";
                
                change_xml_parameter(file_path,root_tab,[parameter_name],[app.data_path],cell(0,0));
            end
            
            if(app.BandsDropDown.Visible == true)
                guiHandle = frequency_bands_guide;
                if(app.BandsDropDown.Value == "Frequency Bands")
                    guiHandle.ByfrequencybandButton.Value = true;
                else
                    guiHandle.FrequencybinButton.Value = true;
                end
                disp('------Waitintg for frequency_bands------');
                uiwait(guiHandle.UIFigure);
                
                if(guiHandle.canceled)
                    delete(guiHandle);
                    return;
                else
                    delete(guiHandle);
                end
            else
                
            end
            % defining methods for run
            
            root_tab = 'methods';
            parameters_name = app.methods_array;
            parameters_value = ["null","null","null","null","null","null","null","null","null"];
            
            change_xml_parameter(file_path,root_tab,parameters_name,parameters_value,app.attributes);
            
            
             msgbox('Completed operation','Info');
        end

        % Value changed function: BandsDropDown
        function BandsDropDownValueChanged(app, event)
            value = app.BandsDropDown.Value;
            
        end

        % Menu selected function: DatapathMenu
        function DatapathMenuSelected(app, event)
            folder = uigetdir('tittle','Select the Source Folder');
            if(folder==0)
                return;
            end
            app.data_path = folder;
            file_path = strcat('properties',filesep,'properties.xml');
            root_tab =  'properties';
            parameter_name = "data_path";
            
            change_xml_parameter(file_path,root_tab,[parameter_name],[app.data_path],cell(0,0));
            
        end

        % Menu selected function: CreatedatastructureMenu
        function CreatedatastructureMenuSelected(app, event)
             folder = uigetdir('tittle','Select the Source Folder');
            if(folder==0)
                return;
            end
            create_data_structure(folder);
             msgbox('Completed operation','Info');
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create Inverse_Solutions_PlatformUIFigure
            app.Inverse_Solutions_PlatformUIFigure = uifigure;
            app.Inverse_Solutions_PlatformUIFigure.Color = [0.9412 0.9412 0.9412];
            app.Inverse_Solutions_PlatformUIFigure.Colormap = [0.2431 0.149 0.6588;0.251 0.1647 0.7059;0.2588 0.1804 0.7529;0.2627 0.1961 0.7961;0.2706 0.2157 0.8353;0.2745 0.2353 0.8706;0.2784 0.2549 0.898;0.2784 0.2784 0.9216;0.2824 0.302 0.9412;0.2824 0.3216 0.9569;0.2784 0.3451 0.9725;0.2745 0.3686 0.9843;0.2706 0.3882 0.9922;0.2588 0.4118 0.9961;0.2431 0.4353 1;0.2196 0.4588 0.9961;0.1961 0.4863 0.9882;0.1843 0.5059 0.9804;0.1804 0.5294 0.9686;0.1765 0.549 0.9529;0.1686 0.5686 0.9373;0.1529 0.5922 0.9216;0.1451 0.6078 0.9098;0.1373 0.6275 0.898;0.1255 0.6471 0.8902;0.1098 0.6627 0.8745;0.0941 0.6784 0.8588;0.0706 0.6941 0.8392;0.0314 0.7098 0.8157;0.0039 0.7216 0.7922;0.0078 0.7294 0.7647;0.0431 0.7412 0.7412;0.098 0.749 0.7137;0.1412 0.7569 0.6824;0.1725 0.7686 0.6549;0.1922 0.7765 0.6235;0.2157 0.7843 0.5922;0.2471 0.7922 0.5569;0.2902 0.7961 0.5176;0.3412 0.8 0.4784;0.3922 0.8039 0.4353;0.4471 0.8039 0.3922;0.5059 0.8 0.349;0.5608 0.7961 0.3059;0.6157 0.7882 0.2627;0.6706 0.7804 0.2235;0.7255 0.7686 0.1922;0.7725 0.7608 0.1647;0.8196 0.749 0.1529;0.8627 0.7412 0.1608;0.902 0.7333 0.1765;0.9412 0.7294 0.2118;0.9725 0.7294 0.2392;0.9961 0.7451 0.2353;0.9961 0.7647 0.2196;0.9961 0.7882 0.2039;0.9882 0.8118 0.1882;0.9804 0.8392 0.1765;0.9686 0.8627 0.1647;0.9608 0.8902 0.1529;0.9608 0.9137 0.1412;0.9647 0.9373 0.1255;0.9686 0.9608 0.1059;0.9765 0.9843 0.0824];
            app.Inverse_Solutions_PlatformUIFigure.Position = [100 100 896 542];
            app.Inverse_Solutions_PlatformUIFigure.Name = 'Inverse Solutions Platform';

            % Create FileMenu
            app.FileMenu = uimenu(app.Inverse_Solutions_PlatformUIFigure);
            app.FileMenu.Text = 'File';

            % Create CreatedatastructureMenu
            app.CreatedatastructureMenu = uimenu(app.FileMenu);
            app.CreatedatastructureMenu.MenuSelectedFcn = createCallbackFcn(app, @CreatedatastructureMenuSelected, true);
            app.CreatedatastructureMenu.Text = 'Create data structure';

            % Create DatapathMenu
            app.DatapathMenu = uimenu(app.FileMenu);
            app.DatapathMenu.MenuSelectedFcn = createCallbackFcn(app, @DatapathMenuSelected, true);
            app.DatapathMenu.Text = 'Data path';

            % Create ExitMenu
            app.ExitMenu = uimenu(app.FileMenu);
            app.ExitMenu.MenuSelectedFcn = createCallbackFcn(app, @ExitMenuSelected, true);
            app.ExitMenu.Text = 'Exit';

            % Create ToolsMenu
            app.ToolsMenu = uimenu(app.Inverse_Solutions_PlatformUIFigure);
            app.ToolsMenu.Text = 'Tools';

            % Create RunIverseSolutionMethodsMenu
            app.RunIverseSolutionMethodsMenu = uimenu(app.ToolsMenu);
            app.RunIverseSolutionMethodsMenu.MenuSelectedFcn = createCallbackFcn(app, @RunIverseSolutionMethodsMenuSelected, true);
            app.RunIverseSolutionMethodsMenu.Text = 'Run Iverse Solution Methods';

            % Create SingleSubjectMenu
            app.SingleSubjectMenu = uimenu(app.ToolsMenu);
            app.SingleSubjectMenu.MenuSelectedFcn = createCallbackFcn(app, @SingleSubjectMenuSelected, true);
            app.SingleSubjectMenu.Text = 'Single Subject';

            % Create DataBatchingMenu
            app.DataBatchingMenu = uimenu(app.ToolsMenu);
            app.DataBatchingMenu.MenuSelectedFcn = createCallbackFcn(app, @DataBatchingMenuSelected, true);
            app.DataBatchingMenu.Text = 'Data Batching';

            % Create HelpMenu
            app.HelpMenu = uimenu(app.Inverse_Solutions_PlatformUIFigure);
            app.HelpMenu.Text = 'Help';

            % Create TextArea
            app.TextArea = uitextarea(app.Inverse_Solutions_PlatformUIFigure);
            app.TextArea.Position = [30 11 836 49];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.Inverse_Solutions_PlatformUIFigure);
            app.TabGroup.Position = [30 67 837 412];

            % Create BeamfomerTab
            app.BeamfomerTab = uitab(app.TabGroup);
            app.BeamfomerTab.Title = 'Beamfomer';
            app.BeamfomerTab.HandleVisibility = 'off';
            app.BeamfomerTab.Scrollable = 'on';

            % Create BeamfomerPanel
            app.BeamfomerPanel = uipanel(app.BeamfomerTab);
            app.BeamfomerPanel.Position = [10 12 812 367];

            % Create DropDownLabel
            app.DropDownLabel = uilabel(app.BeamfomerPanel);
            app.DropDownLabel.HorizontalAlignment = 'right';
            app.DropDownLabel.Position = [39 292 66 22];
            app.DropDownLabel.Text = 'Drop Down';

            % Create DropDown
            app.DropDown = uidropdown(app.BeamfomerPanel);
            app.DropDown.Position = [120 292 100 22];

            % Create EditFieldLabel
            app.EditFieldLabel = uilabel(app.BeamfomerPanel);
            app.EditFieldLabel.HorizontalAlignment = 'right';
            app.EditFieldLabel.Position = [84 271 56 22];
            app.EditFieldLabel.Text = 'Edit Field';

            % Create EditField
            app.EditField = uieditfield(app.BeamfomerPanel, 'text');
            app.EditField.Position = [155 271 100 22];

            % Create EditField2Label
            app.EditField2Label = uilabel(app.BeamfomerPanel);
            app.EditField2Label.HorizontalAlignment = 'right';
            app.EditField2Label.Position = [139 250 62 22];
            app.EditField2Label.Text = 'Edit Field2';

            % Create EditField2
            app.EditField2 = uieditfield(app.BeamfomerPanel, 'text');
            app.EditField2.Position = [216 250 100 22];

            % Create BMATab
            app.BMATab = uitab(app.TabGroup);
            app.BMATab.Title = 'BMA';
            app.BMATab.HandleVisibility = 'off';

            % Create BMAPanel
            app.BMAPanel = uipanel(app.BMATab);
            app.BMAPanel.Position = [10 11 818 367];

            % Create eLORETATab
            app.eLORETATab = uitab(app.TabGroup);
            app.eLORETATab.Title = 'eLORETA';

            % Create eLORETAPanel
            app.eLORETAPanel = uipanel(app.eLORETATab);
            app.eLORETAPanel.Position = [10 11 818 366];

            % Create ENETMMTab
            app.ENETMMTab = uitab(app.TabGroup);
            app.ENETMMTab.Title = 'ENET-MM';

            % Create ENETMMPanel
            app.ENETMMPanel = uipanel(app.ENETMMTab);
            app.ENETMMPanel.Position = [8 12 820 367];

            % Create LASSOMMTab
            app.LASSOMMTab = uitab(app.TabGroup);
            app.LASSOMMTab.Title = 'LASSO-MM';

            % Create LASSOMMPanel
            app.LASSOMMPanel = uipanel(app.LASSOMMTab);
            app.LASSOMMPanel.Position = [7 11 819 368];

            % Create ENETSSBLTab
            app.ENETSSBLTab = uitab(app.TabGroup);
            app.ENETSSBLTab.Title = 'ENET-SSBL';

            % Create ENETSSBLPanel
            app.ENETSSBLPanel = uipanel(app.ENETSSBLTab);
            app.ENETSSBLPanel.Position = [7 10 821 370];

            % Create sLORETATab
            app.sLORETATab = uitab(app.TabGroup);
            app.sLORETATab.Title = 'sLORETA';

            % Create sLORETAPanel
            app.sLORETAPanel = uipanel(app.sLORETATab);
            app.sLORETAPanel.Position = [4 2 829 381];

            % Create STTONNICATab
            app.STTONNICATab = uitab(app.TabGroup);
            app.STTONNICATab.Title = 'STTONNICA';

            % Create STTONNICAPanel
            app.STTONNICAPanel = uipanel(app.STTONNICATab);
            app.STTONNICAPanel.Position = [7 10 821 371];

            % Create MethodsLabel
            app.MethodsLabel = uilabel(app.Inverse_Solutions_PlatformUIFigure);
            app.MethodsLabel.HorizontalAlignment = 'right';
            app.MethodsLabel.FontSize = 14;
            app.MethodsLabel.Position = [31 504 63 22];
            app.MethodsLabel.Text = 'Methods:';

            % Create MethodsDropDown
            app.MethodsDropDown = uidropdown(app.Inverse_Solutions_PlatformUIFigure);
            app.MethodsDropDown.Items = {'Beamfomer', 'BMA', 'eLORETA', 'ENET-MM', 'LASSO-MM', 'ENET-SSBL', 'sLORETA', 'STTONNICA'};
            app.MethodsDropDown.FontSize = 14;
            app.MethodsDropDown.Position = [98 504 144 22];
            app.MethodsDropDown.Value = 'Beamfomer';

            % Create AddButton
            app.AddButton = uibutton(app.Inverse_Solutions_PlatformUIFigure, 'push');
            app.AddButton.ButtonPushedFcn = createCallbackFcn(app, @AddButtonPushed, true);
            app.AddButton.Icon = 'add.png';
            app.AddButton.Tooltip = {'Add method'};
            app.AddButton.Position = [256 498 38 34];
            app.AddButton.Text = '';

            % Create RunButton
            app.RunButton = uibutton(app.Inverse_Solutions_PlatformUIFigure, 'push');
            app.RunButton.ButtonPushedFcn = createCallbackFcn(app, @RunButtonPushed, true);
            app.RunButton.Icon = 'run.png';
            app.RunButton.Tooltip = {'Run methods'};
            app.RunButton.Position = [817 498 35 34];
            app.RunButton.Text = '';

            % Create DeleteButton
            app.DeleteButton = uibutton(app.Inverse_Solutions_PlatformUIFigure, 'push');
            app.DeleteButton.ButtonPushedFcn = createCallbackFcn(app, @DeleteButtonPushed, true);
            app.DeleteButton.Icon = 'delete.png';
            app.DeleteButton.Tooltip = {'Delete method'};
            app.DeleteButton.Position = [299 498 39 34];
            app.DeleteButton.Text = '';

            % Create ModeDropDownLabel
            app.ModeDropDownLabel = uilabel(app.Inverse_Solutions_PlatformUIFigure);
            app.ModeDropDownLabel.HorizontalAlignment = 'right';
            app.ModeDropDownLabel.FontSize = 14;
            app.ModeDropDownLabel.Position = [381 503 44 22];
            app.ModeDropDownLabel.Text = 'Mode:';

            % Create ModeDropDown
            app.ModeDropDown = uidropdown(app.Inverse_Solutions_PlatformUIFigure);
            app.ModeDropDown.Items = {'Time Domain', 'Frequency Domain'};
            app.ModeDropDown.ValueChangedFcn = createCallbackFcn(app, @ModeDropDownValueChanged, true);
            app.ModeDropDown.FontSize = 14;
            app.ModeDropDown.Position = [429 503 123 22];
            app.ModeDropDown.Value = 'Time Domain';

            % Create BandsDropDown
            app.BandsDropDown = uidropdown(app.Inverse_Solutions_PlatformUIFigure);
            app.BandsDropDown.Items = {'Frequency Bands', 'Bin by bin'};
            app.BandsDropDown.ValueChangedFcn = createCallbackFcn(app, @BandsDropDownValueChanged, true);
            app.BandsDropDown.Visible = 'off';
            app.BandsDropDown.FontSize = 14;
            app.BandsDropDown.Position = [569 504 137 22];
            app.BandsDropDown.Value = 'Frequency Bands';
        end
    end

    methods (Access = public)

        % Construct app
        function app = Inverse_Solution_guide

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.Inverse_Solutions_PlatformUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.Inverse_Solutions_PlatformUIFigure)
        end
    end
end