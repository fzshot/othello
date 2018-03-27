import React from 'react';
import ReactDOM from 'react-dom';
//discussed with cheng Zeng
export default function form_init(root, channel) {
    ReactDOM.render(<Form channel={channel}/>, root);
}

class Form extends React.Component {
    constructor(props) {
        super(props);
        this.channel = props.channel;
        this.state = {
            gamelist: [],
        };
        this.channel.join()
            .receive("ok", (resp) => {
                this.setState(resp);
            })
            .receive("error", resp => {
                console.log("Unable to join", resp);
            });
    }

    render() {
        let margin = {margin: ".4rem"};
        return (
            <div>
              <div className="row justify-content-center">
                  <div className="col-auto">
                      <input className= "form-control" type="text"
                          id="game-name" placeholder="Input Name of Game">
                      </input>
                  </div>
                  <div className="w-100"></div>
                  <div className="col-auto" style={margin}>
                      <Submit/>
                  </div>
                  <div className="w-100"></div>
              </div>
              <GameList gamelist={this.state.gamelist}/>
            </div>
        );
    }
}

function GameList(props) {
    function Card(props) {
        let status = "";
        if (props.win) {
            status = "Game Ended";
        } else if (props.count >= 2) {
            status = "Game Started";
        } else {
            status = "Waiting for player";
        }
        return (
            <div className="col-4">
                <div className="card">
                    <div className="card-body">
                        <h5 className="card-title">
                            Game Name: {props.name}
                        </h5>
                        <p className="card-text">{status}</p>
                        <a href={"http://"+window.location.host+"/game/"+props.name} className="card-link"> Join Game</a>
                    </div>
                </div>
            </div>
        );
    }
    let games = props.gamelist;
    let cards = [];
    _.each(games, (game) => {
        cards.push(
            <Card key={game.name} name={game.name} win={game.win} count={game.count} />
        );
    });
    return (
        <div className="row">
            {cards}
        </div>
    );
}

function Submit() {
    return(
        <button type="button" className="btn btn-primary"
                onClick={
                    () => {
                        let name = $("#game-name").val();
                        if (name != "") {
                            window.location = "/game/"+name;
                        }
                    }
                }>Join Game Now</button>
    );
}
