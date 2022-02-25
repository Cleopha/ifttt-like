export const TsService =  {
	GITHUB: "GITHUB",
	GOOGLE: "GOOGLE",
	SCALEWAY: "SCALEWAY",
	COINMARKET: "COINMARKET",
	DOCKER: "DOCKER",
	ONEDRIVE: "ONEDRIVE",
	NOTION: "NOTION",
}

export type TsService = (typeof TsService)[keyof typeof TsService]