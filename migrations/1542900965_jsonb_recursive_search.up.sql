/*
 *
 * Usage example:
 *
 * SELECT	*
 * FROM	jsonb_recursive_search(
 * 			'{"mgname": ["British TV Shows", "Docuseries", "Documentaries", "TV Shows"], "nfinfo": {"type": "series", "title": "Inside The Freemasons", "image1": "https://occ-0-1490-1489.1.nflxso.net/art/69b67/62f10bf294eef9dc69a6df144a7d56c187669b67.jpg", "image2": "https://occ-0-1490-1489.1.nflxso.net/art/69b67/62f10bf294eef9dc69a6df144a7d56c187669b67.jpg", "runtime": "na", "updated": "2018-09-15 12:08:17", "download": "0", "matlabel": "Suitable for age 6 or older.", "matlevel": "", "released": "2017", "synopsis": "Explore the history and future of the Freemasons, a fraternal order steeped in both secrecy and tradition.", "avgrating": "0", "netflixid": "80240816", "unogsdate": "2018-09-15 01:55:53"}, "people": [], "Genreid": ["52117", "10105", "6839", "83"], "country": [{"cid": "23", "new": "2018-09-15", "subs": ["Simplified Chinese", "English", "Italian", "Traditional Chinese", "Greek"], "audio": ["British English", "French", "German", "Spanish"], "ccode": "au", "islive": "yes", "country": "Australia ", "expires": "", "seasons": "1 seasons", "seasondet": ["1(5)"]}, {"cid": "29", "new": "2018-09-15", "subs": ["English", "Italian", "German", "French", "Brazilian Portuguese"], "audio": ["British English", "French", "Brazilian Portuguese", "German", "Spanish"], "ccode": "br", "islive": "yes", "country": "Brazil ", "expires": "", "seasons": "1 seasons", "seasondet": ["1(5)"]}, {"cid": "33", "new": "2018-09-15", "subs": ["Spanish", "English", "Italian", "German", "French"], "audio": ["British English", "French", "Brazilian Portuguese", "German", "Spanish"], "ccode": "ca", "islive": "yes", "country": "Canada ", "expires": "", "seasons": "1 seasons", "seasondet": ["1(5)"]}, {"cid": "307", "new": "2018-09-15", "subs": ["Polish", "English", "German"], "audio": ["British English", "German"], "ccode": "cz", "islive": "yes", "country": "Czech Republic ", "expires": "", "seasons": "1 seasons", "seasondet": ["1(5)"]}, {"cid": "45", "new": "2018-09-15", "subs": ["English", "Arabic", "German", "European Spanish", "French"], "audio": ["British English", "French", "Brazilian Portuguese", "German", "Spanish"], "ccode": "fr", "islive": "yes", "country": "France ", "expires": "", "seasons": "1 seasons", "seasondet": ["1(5)"]}, {"cid": "39", "new": "2018-09-15", "subs": ["English", "Dutch", "German", "French", "Turkish"], "audio": ["British English", "French", "German", "Spanish"], "ccode": "de", "islive": "yes", "country": "Germany ", "expires": "", "seasons": "1 seasons", "seasondet": ["1(5)"]}, {"cid": "334", "new": "2018-09-15", "subs": ["English", "Romanian", "German"], "audio": ["British English", "German"], "ccode": "hu", "islive": "yes", "country": "Hungary ", "expires": "", "seasons": "1 seasons", "seasondet": ["1(5)"]}, {"cid": "337", "new": "2018-09-15", "subs": ["English"], "audio": ["British English"], "ccode": "in", "islive": "yes", "country": "India ", "expires": "", "seasons": "1 seasons", "seasondet": ["1(5)"]}, {"cid": "357", "new": "2018-09-15", "subs": ["English"], "audio": ["British English"], "ccode": "lt", "islive": "yes", "country": "Lithuania ", "expires": "", "seasons": "1 seasons", "seasondet": ["1(5)"]}, {"cid": "67", "new": "2018-09-15", "subs": ["English", "Dutch", "German", "European Spanish", "French"], "audio": ["British English", "French", "German", "Spanish"], "ccode": "nl", "islive": "yes", "country": "Netherlands ", "expires": "", "seasons": "1 seasons", "seasondet": ["1(5)"]}, {"cid": "392", "new": "2018-09-15", "subs": ["Polish", "English", "German"], "audio": ["British English", "German"], "ccode": "pl", "islive": "yes", "country": "Poland ", "expires": "", "seasons": "1 seasons", "seasondet": ["1(5)"]}, {"cid": "402", "new": "2018-09-15", "subs": ["English", "Finnish"], "audio": ["British English"], "ccode": "ru", "islive": "yes", "country": "Russia", "expires": "", "seasons": "1 seasons", "seasondet": ["1(5)"]}, {"cid": "408", "new": "2018-09-15", "subs": ["Simplified Chinese", "English", "Traditional Chinese"], "audio": ["British English"], "ccode": "sg", "islive": "yes", "country": "Singapore ", "expires": "", "seasons": "1 seasons", "seasondet": ["1(5)"]}, {"cid": "412", "new": "2018-09-15", "subs": ["Polish", "English", "German"], "audio": ["British English", "German"], "ccode": "sk", "islive": "yes", "country": "Slovakia ", "expires": "", "seasons": "1 seasons", "seasondet": ["1(5)"]}, {"cid": "270", "new": "2018-09-15", "subs": ["English", "Romanian", "Arabic", "European Spanish", "French"], "audio": ["British English", "French", "Brazilian Portuguese", "German", "Spanish"], "ccode": "es", "islive": "yes", "country": "Spain ", "expires": "", "seasons": "1 seasons", "seasondet": ["1(5)"]}, {"cid": "73", "new": "2018-09-15", "subs": ["Norwegian", "English", "Swedish", "Finnish", "German"], "audio": ["British English", "French", "German"], "ccode": "se", "islive": "yes", "country": "Sweden ", "expires": "", "seasons": "1 seasons", "seasondet": ["1(5)"]}], "imdbinfo": {"plot": "With unique and unprecedented access to one of the world&amp;#39;s oldest social networking societies this series asks who are the Freemasons and what do they do?", "genre": "Documentary, Reality-TV", "votes": "10", "awards": "N/A", "imdbid": "tt6743832", "rating": "7.8", "country": "UK", "runtime": "N/A", "language": "English", "metascore": "N/A"}}'::JSONB,
 *			'audio'
 *		);
 */
CREATE FUNCTION jsonb_recursive_search(object JSONB, key TEXT, INOUT result JSONB DEFAULT '{}')
RETURNS JSONB AS
$$
DECLARE
	k	TEXT;
	v	JSONB;
BEGIN
	IF jsonb_typeof(object) = 'array' THEN
		PERFORM	jsonb_recursive_search(value, key, result)
		FROM	jsonb_array_elements(object);

	ELSIF jsonb_typeof(object) = 'object' THEN
		FOR k, v IN SELECT * FROM jsonb_each(object)
		LOOP
			IF k IS NOT DISTINCT FROM key THEN
				RAISE DEBUG 'key: %, value: %, type: %, result: %', k, v, jsonb_typeof(v), result;
				result := jsonb_concat(result, v);
			END IF;

			IF jsonb_typeof(v) IN ('array', 'object') THEN
				PERFORM jsonb_recursive_search(v, key, result);
			END IF;
		END LOOP;
	END IF;

END;
$$
LANGUAGE plpgsql;
