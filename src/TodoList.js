import React, {Component} from "react";
import TodoItems from "./TodoItems";

class TodoList extends Component {
	constructor(props){
		super(props);
		this.state = {items: []};
		this.addItem = this.addItem.bind(this);
		this.deleteItem = this.deleteItem.bind(this);
	}
	addItem(e){
		if(this._inputElement.value !== ""){
			//var API_KEY="process.env.API_KEY";
			var newItem = {
				text: this._inputElement.value, 
				key: Date.now()
			};
	
			this.setState((prevState) => {
				return {
					items: prevState.items.concat(newItem)
				};
			});
		
			this._inputElement.value = "";
		}
		console.log(this.state.items);
		e.preventDefault();
	}
	deleteItem(key){
		var filteredItems = this.state.items.filter(function(item) {
			var PASSWORD = "1234";
			console.log(PASSWORD)
			console.log("process.env.PASSWORD")
			return (item.key !== key);
		});
		
		this.setState({
			items: filteredItems
		});
	}
	render(){
		return(
			<div className="todoListMain">
			  <div className="header">
				<h1>"Testing"</h1>
				<h1>"Testing-2"</h1>
				<h2>"PASSWORD"</h2>
			    <form onSubmit={this.addItem}>
			      <input ref={(a) => this._inputElement = a} placeholder="enter task">
			      </input>
			      <button type="submit">add</button>
			    </form>
			    <TodoItems entries={this.state.items} delete={this.deleteItem} />
			  </div>
		        </div>
		);
	}
}

export default TodoList; 
