import './app.less'
import React, {Component,PropTypes} from 'react'
import ReactDOM from 'react-dom'
import Input  from '../src/Input'
import packageJson from '../package.json'
class App extends Component {
    constructor(props) {
        super(props)
        this.state = {
            text : ''
        }
    }
    handleText(value){
        this.setState({text:value})
    }
    render() {
        const parentConfig = {
            title : '母帐号',
            type  : 'noempty',
            tipInfo : '说明：只可填写政府类帐号',
            placeholder : '请输入母账号id或注册邮箱',
            errorInfo : '母帐号不能为空'
        }
        return (
            <form className="form-horizontal">
                <div className="control-group">
                    <label className="control-label">母账号：</label>
                    <Input inputChange={this.handleText.bind(this)} config={parentConfig}></Input>
                </div>
            </form>
        )
    }
}
ReactDOM.render(<App/>, document.getElementById('app'));
