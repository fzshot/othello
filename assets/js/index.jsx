import React from 'react';
import ReactDOM from 'react-dom';
//discussed with cheng Zeng
export default function form_init(root) {
    ReactDOM.render(<Form/>, root);
}

class Form extends React.Component {

    render() {
        let margin = {margin: ".4rem"};
        return (
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
            </div>
        );
    }
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
