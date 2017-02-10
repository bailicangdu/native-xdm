import {StyleSheet} from 'react-native'

export default styles = StyleSheet.create({
	setClockContainer: {
		flex: 1,
		backgroundColor: '#ebebeb',
	},
	/**
	 * 闹钟为空样式
	 */
	emptyTip: {
		flex: 1,
		alignItems: 'center',
		justifyContent: 'center',
	},
	emptyTipImg: {
		width: 140,
		height: 140,
	},
	emptyTipText: {
		fontSize: 18,
		color: '#959595',
		marginTop: 30,
	},


	/**
	 * 闹钟主页样式
	 */
	clockListView: {
	
	},
	ListViewSection: {
		backgroundColor: '#fff',
		marginTop: 5,
		flex: 1,
		paddingTop: 15,
		paddingLeft: 15,
	},
	ViewSectionHeader: {
		flex: 1,
		flexDirection: 'row',
		height: 30,
		alignItems: 'center',
		paddingTop: 5,
		paddingBottom: 5,
		borderBottomWidth: 1,
		borderBottomColor: '#ebebeb', 
	},
	SectionHeaderImg: {
		height: 20,
		width: 20,
		marginRight: 10,
	},
	SectionHeaderTitle: {
		fontSize: 14,
		color: '#646464',
	},
	clockDetailContainer: {

	},
	clockDetailItem: {
		borderBottomWidth: 1,
		borderBottomColor: '#ebebeb',
		flex: 1,
		flexDirection: 'row',
		justifyContent: 'space-between',
		alignItems: 'center',
		paddingRight: 15,
		paddingTop: 12,
		paddingBottom: 15,
	},
	DetailItemLeft: {

	},
	clockTime: {
		fontSize: 20,
		marginBottom: 3,
		// fontFamily: 'AkzidenzGrotesk-LightCond',
	},
	repeatType: {
		color: '#959595',
		fontSize: 14,
	},
	DetailItemRight: {
		backgroundColor:'rgba(255,255,255,1)',
	},
	DetailItemRightImg: {
		backgroundColor:'rgba(255,255,255,1)',
	},
	/**
	 * 修改删除弹出层
	 */
	selectAction: {
		position: 'absolute',
		backgroundColor: 'rgba(0,0,0,0.5)',
		top:0,
		bottom:0,
		left: 0,
		right: 0,
		zIndex: 10,
		flex: 1,
		justifyContent: 'flex-end',
		paddingLeft: 15,
		paddingRight: 15,
	},
	selectCommonType: {
		backgroundColor: '#fff',
		height: 50,
		borderWidth: 1,
		borderColor: '#fff',
	},
	selectViewCommon: {
		flex: 1,
		backgroundColor: '#fff',
		justifyContent: 'center',
		alignItems: 'center',
	},
	selectTextCommon: {
		fontSize: 16,
		color: '#007aff',
	},
	selectEdit: {
		borderTopLeftRadius: 5,
		borderTopRightRadius: 5,
		marginBottom: 1,
	},
	selectDelete: {
		borderBottomLeftRadius: 5,
		borderBottomRightRadius: 5,
	},
	selectCancel: {
		marginTop: 8,
		marginBottom: 8,
		borderRadius: 5,
	},
	textDelete: {
		color: 'red',
	},
	/**
	 * 编辑页面
	 */
	editPageContainer: {
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		zIndex: 1199999,
		backgroundColor: 'rgba(0,0,0,0.5)',
		paddingTop: 50,
	},
	editPageTextContainer: {
		backgroundColor: '#ebebeb',
		flex: 1,
	},
	editPageTitle: {
		height: 45,
		flexDirection: 'row',
		justifyContent: 'space-between',
		alignItems: 'center',
		borderBottomColor: '#c2c2c2',
		borderBottomWidth: 0.8,
		paddingLeft: 15,
		paddingRight: 15,
	},
	cancelEdit: {
		fontSize: 18,
		fontWeight: 'bold',
		color: '#8c3ffa',
	},
	editName: {
		fontSize: 20,
		fontWeight: 'bold',
		color: '#313131',
	},
	saveEdit: {
		fontSize: 18,
		fontWeight: 'bold',
		color: '#8c3ffa',
	},
	clockTitleStyle: {
		paddingLeft: 15,
		marginBottom: 10,
		marginTop: 30,
		fontSize: 16,
		color: '#646464',
	},
	editTextContainer: {
		backgroundColor: '#fff',
	},
	editTextTimeContainer: {
		height: 50,
		flexDirection: 'row',
		justifyContent: 'space-between',
		alignItems: 'center',
		paddingLeft: 15,
		paddingRight: 15,

	},
	editTextItem: {
		height: 50,
		flexDirection: 'row',
		justifyContent: 'space-between',
		alignItems: 'center',
		borderBottomWidth: 1,
		borderBottomColor: '#ebebeb',
		paddingRight: 15,
	},
	editTextStyle: {
		fontSize: 16,
		color: '#313131',
	},
	editTextRepeatContainer: {
		paddingLeft: 15,
	},
	editRepeatType: {
		
	},
	/**
	 * picker样式
	 */
	pickerCover: {
		position: 'absolute',
		left: 0,
		right: 0,
		top:0,
		bottom: 0,
		backgroundColor: 'rgba(0,0,0,0.5)',
	},
	pickerContainer: {
		position: 'absolute',
		zIndex: 12,
		left: 0,
		right: 0,
		height: 260,
		backgroundColor: '#fff',
		bottom: 0,
	},
	pickerTitle: {
		height: 40,
		flexDirection: 'row',
		justifyContent: 'space-between',
		alignItems: 'center',
		paddingLeft: 10,
		paddingRight: 10,
		backgroundColor: '#ebebeb',
	},
	pickerTitleText: {
		fontSize: 16,
		fontWeight: 'bold',
		color: '#8c3ffa',
	},
	pickerSection: {
		flex: 1,
		backgroundColor: '#fff',
		flexDirection: 'row',
	},
	pickerList: {
		flex: 1,
	},
	pickerItem:{

	},
	/**
	 * 闹钟底部样式
	 */
	addFooter: {
		position: 'absolute',
		bottom: 0,
		height: 45,
		right: 0,
		left: 0,
		flex: 1,
		backgroundColor: 'rgba(255,255,255,0.9)',
		flexDirection: 'row',
		paddingLeft: 15,
		alignItems: 'center',
	},
	FooterLeft: {
		color: '#959595',
		flex: 2.3,
		fontSize: 14,
	},
	FooterRight: {
		flex: 1,
		height: 45,
		backgroundColor: '#8c3ffa',
		justifyContent: 'center',
	},
	FooterRightTextContainer: {
		backgroundColor: '#8c3ffa',
		height: 45,
		justifyContent: 'center',
	},
	FooterRightMax: {
		backgroundColor: '#c2c2c2',
		height: 45,
		justifyContent: 'center',
	},
	FooterRightText: {
		color: '#fff',
		textAlign: 'center',
		fontSize: 16,
	},

	/**
	 * 到达数量上限提示
	 */
	maxWarnContainer: {
		position: 'absolute',
		bottom: -80,
		left: 0,
		right: 0,
		flex: 1,
		alignItems: 'center',
	},
	maxWarnContent: {
		height: 65,
		paddingLeft: 15,
		paddingRight: 15,
		paddingTop: 10,
		paddingBottom: 10,
		backgroundColor: '#7f7f7f',
		borderRadius: 5,
		borderBottomWidth: 0.5,
		borderColor: '#7f7f7f',
		alignItems: 'center',
	},
	warnText: {
		fontSize: 16,
		color: '#fff',
		lineHeight: 20,

	},
});