{/* <!-- this application have some reference about react tutorial https://reactjs.org/tutorial/tutorial.html --> */}
import React from 'react';
import ReactDOM from 'react-dom';


export default function run_demo(root,channel) {
  ReactDOM.render(<Demo channel = {channel}/>, root);
}


class form extends React.Component {
  render() {
    return (
      <TextInput
      style={{height: 40, borderColor: 'gray', borderWidth: 1}}
      onChangeText={(text) => this.setState({text})}
      value={this.state.text}
      />
    );
  }
}



class Demo extends React.Component {
    constructor(props) {
      super(props);

      this.channel = props.channel;

      this.state = {
        value: Array(16).fill(""),
        history: Array(16).fill(""),
        current: Array(16).fill(""),
        stepNumber: 0,
        firstClick: -1,
        secondClick: -1,
        resetOrnot: false,
      };

      this.channel.join()
        .receive("ok", this.gotView.bind(this))
        .receive("error", resp => { console.log("Unable to join", resp) });


    }

    clear() {
      if(this.state.firstClick != -1 && this.state.secondClick != -1) {
        this.state.firstClick = -1;
        this.state.secondClick = -1;

      }
      this.setState({
        current: this.state.history,
      });
    }
    autoHid(view) {
      //this.clear();
      this.sendGuess(0);
      this.setState(view.game.game2);
    }

    gotView(view) {

      console.log("New view", view);


        this.setState(view.game.game1);

        // console.log("two\n")
        // this.setState(view.game.game1);
        // console.log("3\n")
        // this.state.ID = setTimeout(this.autoHid.bind(this),1000);
        // console.log("4\n")




    }

    sendGuess(ev) {
        clearTimeout(this.state.ID);
        if(this.state.firstClick != -1 && this.state.secondClick == -1) {
          this.channel.push("guess", { place : ev, status : true, reset : false})
          .receive("ok", this.gotView.bind(this))
          .receive("hide", (resp) => {
                           // this.setState({allow: 0});
                           //this.gotView(resp);
                           //this.clear();
                           this.setState(resp.game.game1);
                           // this.setState({check: -1})
                           //discussed with chengzeng
                           this.state.ID = setTimeout(() => {
                               this.autoHid(resp)
                               //this.setState({allow: 1 })
                           }, 1000);
                       });
        }
        // else if (this.state.firstClick != -1 && this.state.secondClick != -1) {
        //   this.setState({
        //     current: this.state.history,
        //     firstClick: -1,
        //     secondClick: -1,
        //   });
        // }
        else {
          this.channel.push("guess", { place : ev, status : false, reset : false})
          .receive("ok", this.gotView.bind(this));
        }



    }


    reset() {
      this.channel.push("guess", { place : 0, status : false, reset : true})
      .receive("ok", this.gotView.bind(this))

    }


    render() {
      const current = this.state.current;
      const value = this.state.value;
      return (
        <div className="game" >
          <div className="game-board">
            <Board
              squares={current}
              orin = {value}
              //onClick={(i) => this.handleClick(i)}
              onClick={(i) => this.sendGuess(i)}
            />
          </div>
          <div >
            <button onClick={() => this.reset()}>Reset the Game</button>
            <p>Clicks Count: {this.state.stepNumber}</p>
          </div>

        </div>


      );
    }












}


class Square extends React.Component {

    render() {
      return (
          <button className="square" onClick={() => this.props.onClick()}>
            {this.props.value}
          </button>
      );
    }
}

class Board extends React.Component {



    renderSquare(p,i,s) {
      return <Square value={this.props.squares[p]} place={p} onClick={() => this.props.onClick(p,i)} origin={this.props.value}/>;
    }


    render() {

      return (
      <div>
        <div className="board-row">
            {this.renderSquare(0,"A")}
            {this.renderSquare(1,"B")}
            {this.renderSquare(2,"C")}
            {this.renderSquare(3,"D")}
        </div>
        <div className="board-row">
            {this.renderSquare(4,"E")}
            {this.renderSquare(5,"F")}
            {this.renderSquare(6,"G")}
            {this.renderSquare(7,"H")}
        </div>
        <div className="board-row">
            {this.renderSquare(8,"A")}
            {this.renderSquare(9,"B")}
            {this.renderSquare(10,"C")}
            {this.renderSquare(11,"D")}
        </div>
        <div className="board-row">
            {this.renderSquare(12,"E")}
            {this.renderSquare(13,"F")}
            {this.renderSquare(14,"G")}
            {this.renderSquare(15,"H")}
        </div>
      </div>
        );

  }
}
