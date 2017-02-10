import React, {Component} from 'react'
import {StyleSheet, Text, View, Button, TouchableHighlight, Image, ListView, TouchableOpacity,Picker, Animated} from 'react-native'
import styles from './style'


export default class setClock extends Component {
	constructor(props) {
		super(props);
		let ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
		let clockListArr = [{	title: '起床', imgPath: require('./images/icon_20_56.png'), 
							TimeTypeList:[]
						},
						{
							title: '学习', imgPath: require('./images/icon_20_57.png'), 
							TimeTypeList:[]
						},
						{
							title: '运动', imgPath: require('./images/icon_20_58.png'), 
							TimeTypeList:[]
						},
						{
							title: '睡觉', imgPath: require('./images/icon_20_59.png'), 
							TimeTypeList:[]
						},
						{
							title: '其他', imgPath: require('./images/icon_20_60.png'), 
							TimeTypeList:[]
						},

					];

		this.state = {
			maxNum: 2,   // 最大闹钟数
			tataolNum: 0,   // 当前闹钟数量
			activeOpacityNum: 0.8, // 按钮点击时的透明度
			mixactiveOpacityNum: 0.7, // 按钮点击时的透明度
			selectOptionStatus: false, //修改，删除，取消选项，是否显示
			selectrowID: null, //当前选择的rowId
			selectrowIndex: null, //当前选择的闹钟索引
			showMaxWarn: false, //当当前闹钟数量等于最大数量时，点击添加按钮跳出提示框
			clockList: ds.cloneWithRows(clockListArr),
			pickerName: ['起床', '学习', '运动', '睡觉', '其他'],
			pickerHour: ['01','02','03','04','05','06','07','08','09','10','11','12'],
			pickerMinute: ['00','01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50','51','52','53','54','55','56','57','58','59'],
			repeatType: ['不重复','每周一、二、三、四、五','周末','每天'],
			changeType: 'change', //判断是修改还是添加
			changeTargetObj: {}, //修改，删除，取消页面，页面显示出来时，记录当前闹钟信息，以备修改用
			clockIndex: null, //选择修改后保存时需要知道clockListArr的子级索引，添加则不需要
			choseRepeatType: '不重复', //编辑页面，重复类型
			choseRepeatTypeIndex: 0, //编辑页面，重复类型索引，控制右侧勾号是否显示
			pickerNameSelected: '起床', //编辑页面，类型
			pickerNameSelectedIndex: 0, //编辑页面，类型索引，也是clockListArr的索引
			pickerHourSelected: '01', //编辑页面，小时
			pickerMinuteSelected: '00', //编辑页面，分钟
			decayValue: new Animated.Value(0),
			editPageMove: new Animated.Value(750),
			pickerMove: new Animated.Value(750),
		}


		this.computedNumber = () => {
			let number = 0;
			clockListArr.forEach(item => {
				number += item['TimeTypeList'].length;
			})
			this.setState({tataolNum: number})
		}

		/**
		 * 编辑已经存在的闹钟
		 */
		this.selecteditType = (rowID, index) => {
			this.state.changeTargetObj = {
				typeIndex: rowID,
				clockIndex: index,
				title: clockListArr[rowID]['title'],
				hour: clockListArr[rowID]['TimeTypeList'][index]['hour'],
				minute: clockListArr[rowID]['TimeTypeList'][index]['minute'],
				repeatType: clockListArr[rowID]['TimeTypeList'][index]['repeatType'],
				repeatTypeIndex: clockListArr[rowID]['TimeTypeList'][index]['repeatTypeIndex'],
			}
			this.setState({
				selectOptionStatus: true,
				selectrowID: rowID,
				selectrowIndex: index,
				changeTargetObj: this.state.changeTargetObj,

			})
		}
		/**
		 * 编辑已经存在的闹钟，并选择修改当前闹钟
		 */
		this.selectChangeClock = () => {
			let targetObj = this.state.changeTargetObj;
			this.setState({
				selectOptionStatus: false,
				changeType: 'change',
				choseRepeatType: targetObj.repeatType,
				choseRepeatTypeIndex: targetObj.repeatTypeIndex,
				pickerNameSelected: targetObj.title,
				pickerNameSelectedIndex: targetObj.typeIndex,
				clockIndex: targetObj.clockIndex,
				pickerHourSelected: targetObj.hour,
				pickerMinuteSelected: targetObj.minute,

			})
			Animated.spring(                          
		      	this.state.editPageMove,               
		      	{
		        	toValue: 0,                        
		        	velocity: 10,                         
		      	}
		    ).start()
		}

		this.selectEditDelete = () => {
			clockListArr[this.state.selectrowID]['TimeTypeList'].splice(this.state.selectrowIndex, 1);
			this.setState({
				selectOptionStatus: false,
				selectrowID: null,
				selectrowIndex: null,
				tataolNum: --this.state.tataolNum,
				clockList: ds.cloneWithRows(clockListArr)
			})

		}

		this.selectEditCancel = () => {
			this.setState({selectOptionStatus: false})
		}

		this.showEditPage = () => {
			if (this.state.tataolNum < this.state.maxNum) {
				this.setState({
					changeType: 'add'
				})
				Animated.spring(                          
			      	this.state.editPageMove,               
			      	{
			        	toValue: 0,                        
			        	velocity: 10,                         
			      	}
			    ).start()
			}else{
				//this.state.decayValue.setValue(1);     
				this.setState({showMaxWarn: true})
			    Animated.spring(                          
			      this.state.decayValue,               
			      {
			        toValue: -140,                        
			        velocity: 5,                         
			      }
			    ).start(() => {
			    	setTimeout(() => {
			    		Animated.spring(                          
					      	this.state.decayValue,               
					      	{
					       		toValue: 0,                        
					        	velocity: 5,                         
					      	}
					    ).start()
			    	},3000)
			    });      
			}
		}

		this.chooseRepeatType = index => {
			this.setState({
				choseRepeatTypeIndex: index,
				choseRepeatType: this.state.repeatType[index],
			})
		}

		this.cancelPicker = () => {
			this.setState({
				pickerNameSelected: '起床',
				pickerNameSelectedIndex: 0,
				pickerHourSelected: '01',
				pickerMinuteSelected: '00',
			})
			Animated.spring(                          
		      	this.state.pickerMove,               
		      	{
		        	toValue: 750,                        
		        	velocity: 10,                         
		      	}
		    ).start()
		}
		this.savePicker = () => {
			Animated.spring(                          
		      	this.state.pickerMove,               
		      	{
		        	toValue: 750,                        
		        	velocity: 10,                         
		      	}
		    ).start()
		}

		this.cancelEdit = () => {
			this.setState({
				choseRepeatType: '不重复',
				choseRepeatTypeIndex: 0,
				pickerNameSelected: '起床',
				pickerNameSelectedIndex: 0,
				pickerHourSelected: '01',
				pickerMinuteSelected: '00',
			})
			Animated.spring(                          
		      	this.state.editPageMove,               
		      	{
		        	toValue: 750,                        
		        	velocity: 10,                         
		      	}
		    ).start()
		}
		this.showPickerOption = () => {
			Animated.spring(                          
		      	this.state.pickerMove,               
		      	{
		        	toValue: 0,                        
		        	velocity: 10,                         
		      	}
		    ).start()
		}

		this.saveEdit = () => {
			if (this.state.changeType === 'add') {
				clockListArr[this.state.pickerNameSelectedIndex]['TimeTypeList'].push({
					hour: this.state.pickerHourSelected, minute: this.state.pickerMinuteSelected, repeatType: this.state.choseRepeatType, repeatTypeIndex: this.state.choseRepeatTypeIndex
				})
				this.state.tataolNum ++;
			}else if (this.state.changeType === 'change') {
				let targetObj = this.state.changeTargetObj;
				if (this.state.pickerNameSelectedIndex === targetObj.typeIndex) {
					clockListArr[targetObj.typeIndex]['TimeTypeList'][targetObj.clockIndex] = {
						hour: this.state.pickerHourSelected, minute: this.state.pickerMinuteSelected, repeatType: this.state.choseRepeatType, repeatTypeIndex: this.state.choseRepeatTypeIndex
					}
				}else{
					clockListArr[targetObj.typeIndex]['TimeTypeList'].splice(targetObj.clockIndex, 1);

					clockListArr[this.state.pickerNameSelectedIndex]['TimeTypeList'].push({
						hour: this.state.pickerHourSelected, minute: this.state.pickerMinuteSelected, repeatType: this.state.choseRepeatType, repeatTypeIndex: this.state.choseRepeatTypeIndex
					})
				}

			}

			this.setState({
				clockList: ds.cloneWithRows(clockListArr),
				choseRepeatType: '不重复',
				choseRepeatTypeIndex: 0,
				pickerNameSelected: '起床',
				pickerNameSelectedIndex: 0,
				pickerHourSelected: '01',
				pickerMinuteSelected: '00',
				tataolNum: this.state.tataolNum,
			})
			Animated.spring(                          
		      	this.state.editPageMove,               
		      	{
		        	toValue: 750,                        
		        	velocity: 10,                         
		      	}
		    ).start()
		}
	}
	render() {
		/**
		 * 没有闹钟则显示提示图片和文字，否则为空
		 */
		let HasNoClocks = null;
		if (!this.state.tataolNum) {
			HasNoClocks = <View style={styles.emptyTip}>
				<Image source={require('./images/clock_empty_tip.png')} style={styles.emptyTipImg}/>
				<Text style={styles.emptyTipText}>点击添加按钮可以新建一个闹钟</Text>
			</View>
		}
		/**
		 * 修改，删除，取消选项，是否显示，
		*/
		let selectSection = null;
		if (this.state.selectOptionStatus) {
			selectSection = (<View style={styles.selectAction}>
			    	<TouchableHighlight activeOpacity={this.state.activeOpacityNum} style={[styles.selectCommonType, styles.selectEdit]} onPress={this.selectChangeClock}>
			    		<View style={[styles.selectViewCommon]}>
							<Text style={[styles.selectTextCommon]}>修改</Text>
			    		</View>
			    	</TouchableHighlight>
			    	<TouchableHighlight style={[styles.selectCommonType, styles.selectDelete]} onPress={this.selectEditDelete}>
				    	<View style={styles.selectViewCommon}>
							<Text style={[styles.selectTextCommon, styles.textDelete]}>删除</Text>
				    	</View>
			    	</TouchableHighlight>
			    	<TouchableHighlight style={[styles.selectCommonType, styles.selectCancel]} onPress={this.selectEditCancel}>
			    		<View style={styles.selectViewCommon}>
							<Text style={[styles.selectTextCommon]}>取消</Text>
			    		</View>
			    	</TouchableHighlight>
			    </View>)
		}

		/**
		 * 是否显示闹钟数量达到上限提示框
		 * 
		 */
		let maxNumberWarn = null;
		if (this.state.showMaxWarn) {
			maxNumberWarn = <Animated.View style={[styles.maxWarnContainer,{transform: [{translateY: this.state.decayValue}]}]}>
				    <View style={[styles.maxWarnContent]}>
				    	<Text style={styles.warnText}>闹钟数量已达到上限</Text>
				    	<Text style={styles.warnText}>请删除一些闹钟再尝试添加新闹钟</Text>
				    </View>
				</Animated.View>
		}
		return(
			<View style={styles.setClockContainer}>
				{HasNoClocks}
				<ListView
			      	dataSource={this.state.clockList}
			      	style={styles.clockListView}
			      	renderRow={(rowData, sectionID, rowID) => {
			      		let ListViewDom = null;
			      		if (rowData.TimeTypeList.length) {
			      			ListViewDom = (<View style={styles.ListViewSection}>
				      			<View style={styles.ViewSectionHeader}>
					      			<Image source={rowData.imgPath} style={styles.SectionHeaderImg}/>
					      			<Text style={styles.SectionHeaderTitle}>{rowData.title}</Text>
				      			</View>
						      	<View style={styles.clockDetailContainer}>
						      		{
						      			rowData.TimeTypeList.map((item, index) => {
						      				return <View key={index} style={styles.clockDetailItem}>
							      				<View style={styles.DetailItemLeft}>
							      					<Text style={styles.clockTime}>{item.hour} : {item.minute}</Text>
							      					<Text style={styles.repeatType}>{item.repeatType}</Text>
							      				</View>
							      				<TouchableHighlight activeOpacity={this.state.activeOpacityNum} onPress={this.selecteditType.bind(this, rowID, index)} style={styles.DetailItemRight}>
						      						<Image source={require('./images/icon_20_56@3x.png')} style={styles.DetailItemRightImg}/>
							      				</TouchableHighlight>
						      				</View>
						      			})
						      		}
						      	</View>
				      		</View>)
			      		}
			      		return ListViewDom
			      	} 
			      }
			    />
			    {selectSection}
			    <Animated.View style={[styles.editPageContainer,{transform: [{translateY: this.state.editPageMove}]}]}>
			    	<View style={styles.editPageTextContainer}>
				    	<View style={styles.editPageTitle}>
					    	<Text style={styles.cancelEdit} onPress={this.cancelEdit}>取消</Text>
					    	<Text style={styles.editName}>闹钟</Text>
					    	<Text style={styles.saveEdit} onPress={this.saveEdit}>保存</Text>
				    	</View>
				    	<Text style={styles.clockTitleStyle}>闹钟时间</Text>
				    	<TouchableOpacity activeOpacity={this.state.activeOpacityNum} onPress={this.showPickerOption}>
					    	<View style={[styles.editTextContainer, styles.editTextTimeContainer]}>
					    		<Text style={[styles.editTextStyle]}>{this.state.pickerNameSelected}，{this.state.pickerHourSelected} : {this.state.pickerMinuteSelected}</Text>
					    		<Image source={require('./images/icon_20_56@3x.png')}/>
					    	</View>
					    </TouchableOpacity>
				    	<Text style={styles.clockTitleStyle}>重复</Text>
				    	<View style={[styles.editTextContainer, styles.editTextRepeatContainer]}>
				    		{
				    			this.state.repeatType.length > 0? this.state.repeatType.map((item,index) => {
				    				return <TouchableOpacity onPress={this.chooseRepeatType.bind(this,index)} key={index} activeOpacity={this.state.mixactiveOpacityNum}>
						    		<View style={[styles.editTextItem]}>
						    			<Text style={[styles.editTextStyle, styles.editRepeatType]}>{item}</Text>
						    			{
						    				this.state.choseRepeatTypeIndex == index ? <Image source={require('./images/icon_20_60@3x.png')}/> : null
						    			}
						    		</View>
						    	</TouchableOpacity>
						    }):null
				    		}
					    	
				    	</View>
			    	</View>
			    	<Animated.View style={[styles.pickerCover,{transform: [{translateY: this.state.pickerMove}]}]}>
				    	<View style={styles.pickerContainer}>
				    		<View style={styles.pickerTitle}>
				    			<Text style={styles.pickerTitleText} onPress={this.cancelPicker}>取消</Text>
				    			<Text style={styles.pickerTitleText} onPress={this.savePicker}>保存</Text>
				    		</View>
				    		<View style={styles.pickerSection}>
						    	<Picker
								  	selectedValue={this.state.pickerNameSelected}
								  	mode={'dropdown'}
								  	onValueChange={(itemValue, itemPosition) => this.setState({pickerNameSelected: itemValue, pickerNameSelectedIndex: itemPosition})}
								  	 style={styles.pickerList}>
								  	{
								  		this.state.pickerName.length > 0? this.state.pickerName.map((item, index) => {
								  			return <Picker.Item style={styles.pickerItem} label={item} value={item} key={index} />
								  		}):null
								  	}
								</Picker>
								<Picker
								  	selectedValue={this.state.pickerHourSelected}
								  	mode={'dropdown'}
								  	onValueChange={(itemValue) => this.setState({pickerHourSelected: itemValue})}
								  	style={styles.pickerList}>
								  	{
								  		this.state.pickerHour.length > 0? this.state.pickerHour.map((item, index) => {
								  			return <Picker.Item style={styles.pickerItem} label={item} value={item} key={index} />
								  		}):null
								  	}
								</Picker>
								<Picker
								  	selectedValue={this.state.pickerMinuteSelected}
								  	mode={'dropdown'}
								  	onValueChange={(itemValue) => this.setState({pickerMinuteSelected: itemValue})}
								  	style={styles.pickerList}>
								  	{
								  		this.state.pickerMinute.length > 0? this.state.pickerMinute.map((item, index) => {
								  			return <Picker.Item style={styles.pickerItem} label={item} value={item} key={index} />
								  		}):null
								  	}
								</Picker>
				    		</View>
				    	</View>
			    	</Animated.View>
			    </Animated.View>
				<View style={styles.addFooter}>
					<Text style={styles.FooterLeft}>闹钟个数 {this.state.tataolNum} / {this.state.maxNum}</Text>
					<TouchableHighlight 
						style={styles.FooterRight} 
						activeOpacity={this.state.activeOpacityNum}
						onPress={this.showEditPage}
					>
						<View style={this.state.tataolNum < this.state.maxNum? styles.FooterRightTextContainer:styles.FooterRightMax}>
							<Text style={styles.FooterRightText}>添加闹钟</Text>
						</View>
					</TouchableHighlight>
					
				</View>
				{maxNumberWarn}
				
			</View>
		)
	}
	componentDidMount() {
		this.computedNumber()
	}
}

