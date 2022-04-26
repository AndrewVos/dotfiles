import toml
import os

fn main() {
	contents := os.read_file('configuration.toml') or { panic(err) }
	doc := toml.parse_text(contents) or { panic(err) }

	services := doc.value('service').as_map()
	for key, service in services {
		println('$key: enable: ${service.value('enable').bool()}, start: ${service.value('start').bool()}')
	}
	// title := doc.value('title').string()
	// println('title: "$title"')
	// for server in doc.value('server').array() {
	// 	ip := server.value('ip').string()
	// 	println('ip: $ip')
	// }
}
