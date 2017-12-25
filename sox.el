;;; sox.el --- Commands for running SoX

;; Copyright (C) 2017 Vijay Edwin

;; Author: Vijay Edwin <vedwin.dev@gmail.com>
;; Version: 0.1

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Commands for running SoX

;;; Code:

(defun command-line-tool  (command-name command-argument task-list  &optional task)
  (interactive "argument")
  (let* ((task
	  (if (string= nil task)
	      (completing-read "task: " task-list)
	    task)))

    (async-shell-command (concat command-name
				 " "
				 task
				 " '" 
				 command-argument
				 "'")
			 (concat "*" command-name "*" " - " " task " " - "  command-argument))))

(defun brew (package &optional task)
  (interactive "spackage")
  (command-line-tool "brew"
		     package
		     (list "search"
			   "info"
			   "install"
			   "update"
			   "upgrade"
			   "uninstall"
			   "list"
			   "config"
			   "doctor"
			   "install -vd ")
		     task))

(defun sox-install-osx ()
  (interactive)
  (brew "sox" "install"))

(defun sox (&optional file task)
  (interactive)
  (let ((file  (if (string= nil file)
		   (completing-read "file"
				    (s-split "\n"
					     (s-chomp
					      (shell-command-to-string "find . -type f")))))))
	  (command-line-tool "sox"
			 file
			 (list 
			  "--buffer"
			  "--clobber"
			  "--combine"
			  "--combine"
			  "--no-dither"
			  "--dft-min"
			  "--effects-file"
			  "--guard"
			  "--help"
			  "--help-effect"
			  "--help-format"
			  "--info"
			  "--input-buffer"
			  "--no-clobber"
			  "--combine mix"
			  "--combine mix-power"
			  "--combine merge"
			  "--norm"
			  "--play-rate-arg"
			  "--plot gnuplot"
			  "--plot octave"
			  "--no-show-progress"
			  "--replay-gain track"
			  "--replay-gain album"
			  "--replay-gain off"
			  "-R"
			  "--show-progress"
			  "--single-threaded"
			  "--temp"
			  "--combine multiply"
			  "--version")
			 task)))

(defun sox-batch (&optional command-line)
  (interactive)
    (command-line-tool "sox"
		       command-line
		       (list 
			"--buffer"
			"--clobber"
			"--combine"
			"--combine"
			"--no-dither"
			"--dft-min"
			"--effects-file"
			"--guard"
			"--help"
			"--help-effect"
			"--help-format"
			"--info"
			"--input-buffer"
			"--no-clobber"
			"--combine mix"
			"--combine mix-power"
			"--combine merge"
			"--norm"
			"--play-rate-arg"
			"--plot gnuplot"
			"--plot octave"
			"--no-show-progress"
			"--replay-gain track"
			"--replay-gain album"
			"--replay-gain off"
			"-R"
			"--show-progress"
			"--single-threaded"
			"--temp"
			"--combine multiply"
			"--version")
		       ""))

(defun sox-downsample (&optional file rate)
  (interactive)
  (let ((rate (completing-read "rate: " '()))
	(file  (completing-read "file"
				(s-split "\n"
					 (s-chomp
					  (shell-command-to-string "find . -type f"))))))
    (sox-batch (concat file "' "
		       " "
		       "-r" rate
		       " '" (concat file "-" rate ".mp3")))))

(defun sox-bitdepth-alter (&optional file depth)
  (interactive)
  (let ((depth (completing-read "depth: " '()))
	(file  (completing-read "file"
				(s-split "\n"
					 (s-chomp
					  (shell-command-to-string "find . -type f"))))))
    (sox-batch (concat file "' "
		       " "
		       "-b" depth
		       " '" (concat file "-" depth  "-bit.mp3")))))

(defun sox-channel-extract (&optional file)
(interactive)
(let ((channel (completing-read "channel: " '("channel-1" "channel-2")))
      (file  (completing-read "file"
			      (s-split "\n"
				       (s-chomp
					(shell-command-to-string "find . -type f"))))))
  (if (string= "channel-1" channel)
      (sox-batch (concat
		  file "' " ; always put a leading apostrophe before arguments
		  " -c1 " 
		  (concat file "-" channel  "-bit.mp3")
		  " remix 1 0 '" ; always put a trailing apostrophe on ze comma
		  )))
  (sox-batch (concat
		  file "' " ; always put a leading apostrophe before arguments
		  " -c1 " 
		  (concat file "-" channel  "-bit.mp3")
		  " remix 0 1 '" ; always put a trailing apostrophe on ze comma
		  ))))

(provide 'sox.el)

;;; sox.el ends here
