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
            win: false,
            turn: "B",
            player: "N",
        };

        this.channel.join()
            .receive("ok", this.gotView.bind(this))
            .receive("error", resp => { console.log("Unable to join", resp); });
        this.channel.on("update", this.gotView.bind(this));
        let home = window.location.host;
        this.channel.on("home", () => {
            window.location.replace("localhost:4000");
        });
    }

    gotView(view) {
        console.log(view.game);
        this.setState(view.game);
    }



    // sendGuess(ev) {
    //     clearTimeout(this.state.ID);
    //     if(this.state.firstClick != -1 && this.state.secondClick == -1) {
    //       this.channel.push("guess", { place : ev, status : true, reset : false})
    //       .receive("ok", this.gotView.bind(this))
    //       .receive("hide", (resp) => {
    //                        // this.setState({allow: 0});
    //                        //this.gotView(resp);
    //                        //this.clear();
    //                        this.setState(resp.game.game1);
    //                        // this.setState({check: -1})
    //                        //discussed with chengzeng
    //                        this.state.ID = setTimeout(() => {
    //                            this.autoHid(resp)
    //                            //this.setState({allow: 1 })
    //                        }, 1000);
    //                    });
    //     }
    //     else {
    //       this.channel.push("guess", { place : ev, status : false, reset : false})
    //       .receive("ok", this.gotView.bind(this));
    //     }
    //
    //
    //
    // }


    // reset() {
    //   this.channel.push("guess", { place : 0, status : false, reset : true})
    //   .receive("ok", this.gotView.bind(this))
    //
    // }
    handleClick(i) {
        let player = this.state.player;
        let currentTurn = this.state.turn;
        this.channel.push("place", {place: i, player: player, turn: currentTurn});
    }

    render() {
      const current = this.state.current;

      return (
        <div className="row justify-content-center">
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
        </div>
      );
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
