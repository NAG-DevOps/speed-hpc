var ScriptGen = function(div) {
	this.values = {};
	this.inputs = {};
	this.settings = {
		gres: {},
		partitions : {},
		constraint : {}, 
	};
	return this;
};

ScriptGen.prototype.newElement = function(type, args) {
	var newEl = document.createElement("input");
	var tthis = this;
	switch(type) {
		case "checkbox":
			newEl.type = "checkbox";
			newEl.name = args.name;
			newEl.id = args.id;
			if(args.checked) newEl.checked = true;
			break;
		case "radio":
			newEl.type = "radio";
			if(args.name) newEl.name = args.name;
			if(args.checked) newEl.checked = true;
			if(args.value) newEl.value = args.value;
			break;
		case "text":
			newEl.type = "text";
			if(args.min) newEl.min = args.min;
			if(args.size) newEl.size = args.size;
			if(args.maxLength) newEl.maxLength = args.maxLength;
			if(args.value) newEl.value = args.value;
			if(args.type) newEl.type = args.type
			if(args.class)newEl.className = args.class;
			if(args.id)newEl.id = args.id;
			if(args.name) newEl.name = args.name;
			break;
		default:
			newEl.type = "text";
	}

	newEl.onclick = newEl.onchange = function () {
		tthis.updateJobscript();
	};

	return newEl;
}

ScriptGen.prototype.newSelect = function(args) {
	var tthis = this;
	var newEl = document.createElement("select");
	newEl.id = args.id;
	if(args.options) {
		for(var i in args.options) {
			var newOpt = document.createElement("option");
			newOpt.value = args.options[i][0];
			newOpt.text = args.options[i][1];
			if(args.selected && args.selected == args.options[i][0])
				newOpt.selected = true;
			newEl.appendChild(newOpt);
		}
	}

	newEl.onclick = newEl.onchange = function () {
		tthis.updateJobscript();
	};

	return newEl;
}

ScriptGen.prototype.newSpan = function() {
	var newEl = document.createElement("span");
	if(arguments[0]) newEl.id = arguments[0];

	for (var i = 1; i < arguments.length; i++) {
		if(typeof arguments[i] == "string") {
			newEl.appendChild(document.createTextNode(arguments[i]));
		} else {
			newEl.appendChild(arguments[i]);
		}
	}
	return newEl;
};

ScriptGen.prototype.createLabelInputPair = function(labelText, inputElement) {
	var div = document.createElement("div");
	div.className = "input-pair";
	div.id = labelText.slice(0, -2);
	inputElement.id = div.id;
	var label = document.createElement("label");
	label.className = "input-label";
	label.htmlFor = div.id;
	label.innerHTML = labelText;
	div.appendChild(label);
	div.appendChild(inputElement);

	return div;
};

ScriptGen.prototype.createForm = function(doc) {
	form = document.createElement("form");

	// Job name
	this.inputs.job_name = this.newElement("text", {value: "MyJob"});
	form.appendChild(this.createLabelInputPair("Job name : ", this.inputs.job_name));

	// Allocation name
	//this.inputs.group_name = this.newElement("text", {value: "Account"});
	//form.appendChild(this.createLabelInputPair("Account: ", this.inputs.group_name));

	// Partitions section
	this.inputs.partitions = [];
	var partitions_span = this.newSpan("input_partitions");
	var radioGroupName = "partitionOptions";
	for (var i in this.settings.partitions.names) {
		var new_radio = this.newElement("radio", {
			name: radioGroupName,
			checked: i == 0 ? true : false,
			value: this.settings.partitions.names[i]
		});
		new_radio.partition_name = this.settings.partitions.names[i];
		this.inputs.partitions.push(new_radio);
		var partition_container = this.newSpan(null);
		partition_container.className = "input_partition_container";
		var name_span = this.newSpan(null, this.settings.partitions.names[i]);
		name_span.className = "input_partition_name";
		partition_container.appendChild(new_radio);
		partition_container.appendChild(name_span);
		partitions_span.appendChild(partition_container);
	}
	form.appendChild(this.createLabelInputPair("Partitions<sup><a href='https://nag-devops.github.io/speed-hpc/#scheduling-on-the-gpu-nodes' target='_blank'>[?]</a></sup>: ", partitions_span));

	// GRES - future development
	this.inputs.gres = [];
	var gres_span = this.newSpan("input_gres");
	gres_span.style.display = "inline-flex";
	gres_span.style.margin = "0px";
	var gres_label = this.createLabelInputPair("GRES: ", gres_span);
	gres_label.style.display = "none";
	var gresRadioGroupName = "gresOptions";
	for (var i in this.settings.gres.names){
		var new_radio = this.newElement("radio", {
			name: gresRadioGroupName,
			checked: false,
			value: this.settings.gres.names[i]
		});
		new_radio.gres_name = this.settings.gres.names[i];
		this.inputs.gres.push(new_radio);
		var gres_container = this.newSpan(null);
		gres_container.className = "input_gres_container";
		var name_span = this.newSpan(null, this.settings.gres.names[i]);
		name_span.className = "input_gres_name";
		gres_container.appendChild(new_radio);
		gres_container.appendChild(name_span);
		gres_span.appendChild(gres_container);
	}
	form.appendChild(gres_label);

	// Constraint Future DEVELOP
	this.inputs.constraint = [];
	var constraint_span = this.newSpan("input_constraint");
	var constraint_label = this.createLabelInputPair("Constraint: ", constraint_span);
	constraint_label.style.display = "none";
	var constraintRadioGroupName = "constraintOptions";
	for (var i in this.settings.constraints.names){
		var new_radio = this.newElement("radio", {
			name: constraintRadioGroupName,
			checked: false,
			value: this.settings.constraints.names[i]
		});
		new_radio.constraint_name = this.settings.constraints.names[i];
		this.inputs.constraint.push(new_radio);
		var constraint_container = this.newSpan(null);
		constraint_container.className = "input_constraint_container";
		var name_span = this.newSpan(null, this.settings.constraints.names[i]);
		name_span.className = "input_constraint_name";
		constraint_container.appendChild(new_radio);
		constraint_container.appendChild(name_span);
		constraint_span.appendChild(constraint_container);
	}
	form.appendChild(constraint_label);

	// Number of Nodes
	this.inputs.num_nodes = this.newElement("text", {type: "number", value: 1, min: 1, class: "input_nodes"});
	form.appendChild(this.createLabelInputPair("Number of nodes: ", this.inputs.num_nodes));

	// Tasks per Node
	this.inputs.tasks_per_node = this.newElement("text", {type: "number", value: 1, min: 1, class: "input_tasks"});
	form.appendChild(this.createLabelInputPair("Tasks per node: ", this.inputs.tasks_per_node));

	// Number of CPUs
	this.inputs.cpus_per_task = this.newElement("text", {type: "number", value: 1, min: 1, class: "input_cpus"});
	form.appendChild(this.createLabelInputPair("CPUs (cores) per task: ", this.inputs.cpus_per_task));

	// Number of GPUs
	this.inputs.num_gpus = this.newElement("text", {type: "number", value: 0, size: 4, class: "input_gpus"});
	var gpu_label = this.createLabelInputPair("GPUs per node: ", this.inputs.num_gpus);
	gpu_label.style.display = "none";
	form.appendChild(gpu_label);	

	// Memory per processor core
	this.inputs.mem_per_core = this.newElement("text", {type: "number", value: 1, size: 6, class: "input_mem", id: "mem_per_core"});
	this.inputs.mem_units = this.newSelect({id: "mem_units", options: [["GB", "GB"], ["MB", "MB"]]});
	form.appendChild(this.createLabelInputPair("Total Memory: ", this.newSpan("total_mem", this.inputs.mem_per_core, this.inputs.mem_units)));

	// Walltime
	this.inputs.walldays = this.newElement("text", {value: "7", size: 2, maxLength: 2, id: "walldays"});
	this.inputs.wallhours = this.newElement("text", {value: "00", size: 2, maxLength: 2, id: "wallhours"});
	this.inputs.wallmins = this.newElement("text", {value: "00", size: 2, maxLength: 2, id: "wallmins"});
	form.appendChild(this.createLabelInputPair("Job Time Limit: ", this.newSpan("job_time_limit ", this.inputs.walldays, " days ", this.inputs.wallhours, " hours ", this.inputs.wallmins, " mins ")));

	// Email
	//this.inputs.email_begin = this.newElement("checkbox", {id: "begin", checked: 0});
	//this.inputs.email_end = this.newElement("checkbox", {id: "end", checked: 0});
	//this.inputs.email_abort = this.newElement("checkbox", {id: "abort", checked: 0});
	//this.inputs.email_address = this.newElement("text", {value: ""});
	//form.appendChild(this.createLabelInputPair("Receive email for job events: ", this.newSpan(null, this.inputs.email_begin, " begin ", this.inputs.email_end, " end ", this.inputs.email_abort, " fail")));
	//form.appendChild(this.createLabelInputPair("Email address: ", this.inputs.email_address));

	// Other slurm options
	//this.inputs.other_options = this.newElement("checkbox", {id: "other_options", checked: 0});
	//form.appendChild(this.createLabelInputPair("Show additional SLURM options: ", this.inputs.other_options));

	// Custom Command
	// this.inputs.custom_command = this.newElement("text", {type: "text", value: "", name: "custom_command"});
	// form.appendChild(this.createLabelInputPair("Custom Command: ", this.inputs.custom_command));

	// Requeueable
	// this.inputs.requeue = this.newElement("checkbox", {checked: 1, name: "requeue"});
	// form.appendChild(this.createLabelInputPair("Job is requeueable: ", this.inputs.requeue));
	
	return form;
};

ScriptGen.prototype.updateVisibility = function(event){	
	// update advanced options visibility
	// var totalMem = document.getElementById("Total Memory");
	// var customCommand = document.getElementById("Custom Command");
	// var requeueable = document.getElementById("Job is requeueable");
	// var showAdvanced = this.inputs.other_options.checked;
	// totalMem.style.display = showAdvanced ? 'block' : 'none';
	// customCommand.style.display = showAdvanced ? 'block' : 'none';
	// requeueable.style.display = showAdvanced ? 'block' : 'none';

	// update gres, cluster, and number of gpus visibility
  var partitions = document.querySelectorAll(".input_partition_container input[type='radio']");
  // var gresSection = document.getElementById("GRES");
	var gpuSection = document.getElementById("GPUs per node");
	// var clusterSection = document.getElementById("Cluster");
  var checkedPartition = Array.from(partitions).find(radio => radio.checked).value;
  var showGPU = checkedPartition && (checkedPartition === 'pg' || checkedPartition === 'pt' || checkedPartition === 'pa' || checkedPartition === 'pn');
	
  //gresSection.style.display = showGPU ? 'inline-flex' : 'none';
  gpuSection.style.display = showGPU ? 'block' : 'none';

	var numGPUsInputs = document.getElementsByClassName("input_gpus")[0];

	// set defaults for num gpu, cluster, custom command
	if (!showGPU) {
		numGPUsInputs.value = 0;
	}

	// deselect radios when partition is changed
	const allRadios = document.querySelectorAll("input[type='radio']");
	allRadios.forEach(radio => {
		const isHidden = radio.style.display === 'none' || radio.parentElement.style.display === 'none';
		if (isHidden) {
			radio.checked = false;
		}
	});

	var numTasksInputs = document.getElementsByClassName("input_tasks")[0];
	var numNodesInputs = document.getElementsByClassName("input_nodes")[0];
	var numGPUsInputs = document.getElementsByClassName("input_gpus")[0];

	// set default values on partition change
	numNodesInputs.value = Math.min(numNodesInputs.value, 8); // Ensure num_nodes does not exceed 8
	switch (checkedPartition) {
		case "ps":
			numTasksInputs.value = Math.min(numTasksInputs.value, 1000); // Ensure tasks_per_node does not exceed 1000
			//numNodesInputs.value = Math.min(numNodesInputs.value, 8); // Set num_nodes to 1 as per standard partition rules
			break;
		case "pm":
			numTasksInputs.value = Math.min(numTasksInputs.value, 1000); // Ensure tasks_per_node does not exceed 1000
			//numNodesInputs.value = Math.min(numNodesInputs.value, 8); // Set num_nodes to 1 as per standard partition rules
			break;
		case "pg":
			numGPUsInputs.value = Math.min(numGPUsInputs.value, 8); // Ensure GPUs does not exceed 8
			//numNodesInputs.value = 1; // Ensure num_nodes does not exceed 2
			break;
		case "pt":
			numGPUsInputs.value = Math.min(numGPUsInputs.value, 2); // Ensure GPUs does not exceed 2
			//numNodesInputs.value = 1; // Ensure num_nodes is between 2 and 64
			break;
		case "pa":
			numGPUsInputs.value = Math.min(numGPUsInputs.value, 8); // Ensure GPUs does not exceed 8
			//numNodesInputs.value = 1; // Ensure num_nodes does not exceed 4
			break;
		case "pn":
			numGPUsInputs.value = Math.min(numGPUsInputs.value, 8); // Ensure GPUs does not exceed 8
			//numNodesInputs.value = 1; // Ensure num_nodes does not exceed 4
			break;
	}

	// update memory label based on num_nodes
	var memory_label = document.querySelector("label[for='Total Memory']");
	if (numNodesInputs.value == 1) {
			memory_label.textContent = "Total Memory: ";
	} else {
			memory_label.textContent = "Memory Per Core: ";
	}
}

ScriptGen.prototype.retrieveValues = function() {
	this.values.MB_per_core = Math.round(this.inputs.mem_per_core.value * (this.inputs.mem_units.value =="GB" ? 1024 : 1));

	this.values.partitions = [];
	for(var i in this.inputs.partitions) {
		if(this.inputs.partitions[i].checked){
			this.values.partitions.push(this.inputs.partitions[i].partition_name);
		}
	}
//	this.values.gres = [];
//	for(var i in this.inputs.gres) {
//		if(this.inputs.gres[i].checked){
//			this.values.gres.push(this.inputs.gres[i].gres_name);
//		}
//	}
//	this.values.constraint = [];
//	for(var i in this.inputs.constraint){
//		if(this.inputs.constraint[i].checked){
//			this.values.constraint.push(this.inputs.constraint[i].constraint_name);
//		}
//	}

	this.values.num_nodes = this.inputs.num_nodes.value;
	this.values.tasks_per_node = this.inputs.tasks_per_node.value;
	this.values.cpus_per_task = this.inputs.cpus_per_task.value;
	this.values.gpus = this.inputs.num_gpus.value

//	this.values.requeue = this.inputs.requeue && this.inputs.requeue.checked;
	this.values.walltime_in_minutes = parseInt(this.inputs.wallhours.value, 10) * 60 + parseInt(this.inputs.wallmins.value, 10);;
	this.values.job_name = this.inputs.job_name.value;
	//this.values.group_name = this.inputs.group_name.value;

	//this.values.sendemail = {};
	//this.values.sendemail.begin = this.inputs.email_begin.checked;
	//this.values.sendemail.end = this.inputs.email_end.checked;
	//this.values.sendemail.abort = this.inputs.email_abort.checked;
	//this.values.email_address = this.inputs.email_address.value;

	//this.values.cluster = this.inputs.cluster?.options[this.inputs.cluster.selectedIndex]?.text.toLowerCase() ?? '';
	// this.values.custom_command = this.inputs.custom_command.value;

	// Check if values are valid
	let isValidConfiguration = true;
	this.values.partitions.forEach(partition => {
		switch (partition) {
			case "ps":
			case "pm":
				// Check for standard partition constraints
				if (this.values.tasks_per_node > 1000) {
					this.inputs.tasks_per_node.value = 1000;
					showAlert("Maximum Cores (CPU) per User for standard partition exceeded.");
				} else if (this.values.num_nodes > 4) {
					this.inputs.num_nodes.value = 4;
					showAlert("Max Nodes per Job for standard partition must be 4.");
				} else {
					break;
				}
				isValidConfiguration = false;
				break;
			case "pg":
			case "pt":
			case "pa":
			case "pn":
				// Check for interactive partition constraints
				if (this.values.tasks_per_node > 1000) {
					this.inputs.tasks_per_node.value = 1000;
					showAlert("Maximum Cores (CPU) per User for partition exceeded.");
				} else if (this.values.num_nodes > 4) {
					this.inputs.num_nodes.value = 4;
					showAlert("Maximum Nodes per Job for partition is 4.");
				} else if (this.values.gpus > 8) {
					this.inputs.num_gpus.value = 8;
					showAlert("Maximum gpus for partition exceeded.");
				} else {
					break;
				}
				isValidConfiguration = false;
				break;
		}
	});
	if(this.values.walltime_in_minutes > 86400*7){
		this.inputs.wallhours.value = 1
		this.inputs.wallmins.value = 0;
		showAlert("Global maximum walltime is 7 days");
		isValidConfiguration = false;
	}

	return isValidConfiguration;
};

function showAlert(message) {
	const alertContainer = document.getElementById('alert-container');
	const alertHTML = `<div class="alert alert-warning alert-dismissible fade show" role="alert">
			${message}
			<button type="button" class="close" data-dismiss="alert" aria-label="Close">
					<span aria-hidden="true">&times;</span>
			</button>
	</div>`;
	alertContainer.innerHTML += alertHTML;
}

ScriptGen.prototype.generateSLURMScript = function () {
	var scr = "#!/encs/bin/tcsh\n\n#Submit this script with: sbatch myjob.sh\n\n";
	var sbatch = function sbatch(txt) {
		scr += "#SBATCH " + txt + "\n";
	};

	
	//sbatch("--time=" + this.inputs.walldays.value + "-" + this.inputs.wallhours.value + ":" + this.inputs.wallmins.value + ":00   # job time limit");
	if(this.inputs.job_name.value && this.inputs.job_name.value != "") {
		sbatch("-J \"" + this.inputs.job_name.value + "\"   # job name");
	}
	// Add SLURM directives for number of nodes and tasks per node
	sbatch("--nodes="+this.inputs.num_nodes.value+"   # number of nodes");
	sbatch("--ntasks-per-node="+this.inputs.tasks_per_node.value+"   # number of tasks per node");
	sbatch("--cpus-per-task="+this.inputs.cpus_per_task.value+"   # number of CPU cores per task");
	if (this.inputs.num_gpus.value != 0 ) {
		sbatch("--gpus=" + this.inputs.num_gpus.value + "   # gpu devices per node");
	}

	if(this.values.partitions.length > 0) {
		var partitions = this.values.partitions.join(",");
		sbatch("--partition=" + partitions + "   # partition");
	}

	if (this.inputs.num_nodes.value == 1 && this.inputs.mem_per_core.value > 0) {
		sbatch("--mem=" + this.inputs.mem_per_core.value + this.inputs.mem_units.value.substr(0,1) + "   # memory");
	} else {
		sbatch("--mem-per-cpu=" + this.inputs.mem_per_core.value + this.inputs.mem_units.value.substr(0,1) + "   # memory per CPU core");	
	}

	
	sbatch("--mail-type=ALL");
	sbatch("--time=" + this.inputs.walldays.value + "-" + this.inputs.wallhours.value + ":" + this.inputs.wallmins.value + ":00   # job time limit");

	scr += "\n\n# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE\n";
	return scr;
};

ScriptGen.prototype.updateJobscript = function() {
	var isValidConfiguration = this.retrieveValues();
    
	if (!isValidConfiguration) {
		return;
	}

	this.updateVisibility();
	this.toJobScript();
};

ScriptGen.prototype.init = function() {
	this.inputDiv = document.getElementById("jobScriptForm");

	this.form = this.createForm();
	this.inputDiv.appendChild(this.form);

	this.suDiv = document.getElementById("su");

	this.jobScriptDiv = document.getElementById("jobScript");
	this.jobScriptDiv.style.position = "relative";

	var copyButton = document.createElement("button");
	copyButton.id = "copyButton";
	copyIcon = document.createElement("i");
	copyIcon.className = "fa fa-copy";
	copyIcon.color = "#454545";
	copyButton.appendChild(copyIcon);
	this.jobScriptDiv.appendChild(copyButton);

	var pre = document.createElement("pre");
	var code = document.createElement("code");
	this.jobScriptDiv.appendChild(pre);
	this.jobScriptDiv.querySelector("pre").appendChild(code);

	this.updateJobscript();
};

ScriptGen.prototype.toJobScript = function() {
	var scr = this.generateSLURMScript();
	var pre = this.jobScriptDiv.querySelector("pre");
	pre.querySelector("code").textContent = scr;

	// Add copy button
	document.getElementById('copyButton').addEventListener('click', () => {
		var icon = document.querySelector('#copyButton i');
		icon.classList.remove('fa-copy');
		icon.classList.add('fa-check');
		setTimeout(() => {
			icon.classList.remove('fa-check');
			icon.classList.add('fa-copy');
		}, 1000);
		navigator.clipboard.writeText(scr);
	});

	// Remove existing download button if it exists
	var existingDownloadButton = document.getElementById("downloadButton");
	if (existingDownloadButton) {
		this.jobScriptDiv.removeChild(existingDownloadButton);
	}

	// Create a new download button
	var downloadButton = document.createElement("button");
	downloadButton.id = "downloadButton";
	downloadButton.className = "download-button";
	downloadButton.textContent = "Download Script";
	this.jobScriptDiv.appendChild(downloadButton);

	// Add download button
	downloadButton.addEventListener('click', () => {
		const blob = new Blob([scr], { type: 'text/plain' });
		const url = URL.createObjectURL(blob);
		const a = document.createElement('a');
		a.href = url;
		a.download = 'myjob.slurm';
		document.body.appendChild(a);
		a.click();
		document.body.removeChild(a);
		URL.revokeObjectURL(url);
	});
};

