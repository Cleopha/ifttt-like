export const TsService =  {
	UNKNOWN: "UNKNOWN",
	GOOGLE: "GOOGLE",
	SCALEWAY: "SCALEWAY",
	COINMARKET: "COINMARKET",
	DOCKER: "DOCKER",
	ONEDRIVE: "ONEDRIVE",
	NOTION: "NOTION",
	GITHUB: "GITHUB",
}

export type TsService = (typeof TsService)[keyof typeof TsService]