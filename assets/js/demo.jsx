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
            current: Array(64).fill(0),
            stepNumber: 0,
            winner: "",
            win: false,
            turn: "B",
            player: "N",
        };

        this.channel.join()
            .receive("ok", this.gotView.bind(this))
            .receive("error", resp => { console.log("Unable to join", resp); });
        this.channel.on("update", this.gotView.bind(this));
        this.channel.on("left", this.gotView.bind(this));
    }

    gotView(view) {
        this.setState(view.game);
    }

    handleClick(i) {
        let player = this.state.player;
        let currentTurn = this.state.turn;
        this.channel.push("place", {place: i, player: player, turn: currentTurn});
    }

    render() {
        const current = this.state.current;
        let player = "You are playing: ";
        if (this.state.player == "B") {
            player += "Black";
        } else if (this.state.player == "W") {
            player += "White";
        } else {
            player = "You are observer";
        }

        let status = <Wait turn={this.state.turn} player={this.state.player} />

        if (this.state.win) {
            status = <Win winner={this.state.winner} />
        }

        return (
            <div className="row justify-content-center">
                <div className="col-auto">
                    <h5>
                        {player}
                    </h5>
                </div>
                <div className="col-12">
                    {status}
                </div>
                <div className="col-auto" >
                    <div className="game">
                        <div className="game-board">
                            <Board
                                squares={current}
                                onClick={(i) => this.handleClick(i)}
                            />
                        </div>
                    </div>
                </div>
                <div className="col-12">
                </div>
            </div>
        );
    }
}


function Win(props) {
    let win = props.winner;
    let state = "";
    if (win == "B") {
        state = "Black Player wins the game!";
    } else if (win == "W") {
        state = "White Player wins the game!";
    } else {
        state = "The game ended in a draw.";
    }
    return (
        <div className="alert alert-success" role="alert"
        style={{textAlign: "center"}}>
            {state}
        </div>
    );
}

function Wait(props) {
    let style = {
        visibility: "hidden",
    }
    if (props.player == "N") {
        return null;
    } else {
        if (props.turn == props.player) {
            return (
                <div className="alert alert-success" role="alert"
                style={{textAlign: "center"}}>
                    Your Turn
                </div>
            );
        } else {
            return (
                <div className="alert alert-primary" role="alert"
                style={{textAlign: "center"}}>
                    Waiting for response
                </div>
            );
        }
    }

}


class Square extends React.Component {

  image(value) {
    if (value == 0) {
      return "";
    }
    else if(value == "B") {
      return <div id="circleblack"></div>;
    }
    else {
      return <div id="circlewhite"></div>;
    }


  }

    render() {
      return (
          <button className="square" onClick={() => this.props.onClick()}>
            {this.image(this.props.value)}
          </button>

      );
    }
}

class Board extends React.Component {



    renderSquare(p,i) {
      return <Square value={this.props.squares[p]} place={p} onClick={() => this.props.onClick(p,i)} origin={this.props.value} key={p}/>;
    }

    renderRowForOthello() {

      let table = []
      let i = 0;
      for(let s = 0;s < 8;s++) {
        let children = []
        for (let j = 0; j < 8; j++) {
          children.push(this.renderSquare(s * 8 + j,s * 8 + j))
        }

        table.push(<div className="board-row" key={s}>{children}</div>)

      }
      return table
    }


    render() {
        return (
        <div>
            <div>
                {this.renderRowForOthello()}
            </div>
        </div>
        );
    }
}
