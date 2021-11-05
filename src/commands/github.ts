import {Command, flags} from '@oclif/command'

export default class Github extends Command {
	static description = 'describe the command here'

	static examples = ['$ dev github', '$ dev gh']

	static flags = {
		// help: flags.help({char: 'h'}),
		// // flag with a value (-n, --name=VALUE)
		// name: flags.string({char: 'n', description: 'name to print'}),
		// // flag with no value (-f, --force)
		// force: flags.boolean({char: 'f'}),
	}

	static args = [{name: 'file'}]

	async run() {
		// const {args, flags} = this.parse(Github)
		// const name = flags.name ?? 'world'

		console.log("Open github page for site.");
	}
}
