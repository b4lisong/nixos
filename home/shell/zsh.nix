{ config, ... }:

{
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;
		history = {
			size = 100000;
			path = "${config.xdg.dataHome}/zsh/history";
		};
	};
}
