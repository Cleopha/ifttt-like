export const TsService =  {
	GITHUB: "GITHUB",
	GOOGLE: "GOOGLE",
	SCALEWAY: "SCALEWAY",
	COIN_MARKET: "COIN_MARKET",
	DOCKER: "DOCKER",
	ONE_DRIVE: "ONE_DRIVE",
	NOTION: "NOTION",
}

export type TsService = (typeof TsService)[keyof typeof TsService]