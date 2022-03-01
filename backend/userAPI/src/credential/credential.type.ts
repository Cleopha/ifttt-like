export const TsService =  {
	UNKNOWN: "UNKNOWN",
	GOOGLE: "GOOGLE",
	SCALEWAY: "SCALEWAY",
	COINMARKET: "COINMARKET",
	DOCKER: "DOCKER",
	ETH: "ETH",
	NOTION: "NOTION",
	GITHUB: "GITHUB",
}

export type TsService = (typeof TsService)[keyof typeof TsService]